# join by tabs and then split by double-tabs to find the blank lines
$inp = $($(Get-Content ./Day11/input.txt) -join "`t").Split("`t`t")

class Monkey {
    [System.Collections.ArrayList]$Items;
    $WorryElement;
    $WorryOperator;
    $TestDivisor;
    $TrueTarget;
    $FalseTarget;
    $InspectionCount = 0

    Monkey(
        $itms,
        $w_elem,
        $w_op,
        $divisor,
        $t_target,
        $f_target
    ) {
        $this.Items = $itms
        $this.WorryElement = $w_elem
        $this.WorryOperator = $w_op
        $this.TestDivisor = $divisor
        $this.TrueTarget = $t_target
        $this.FalseTarget = $f_target
    }

    [void] DisplayDetails($Identifier) {
        $Op_String = ""
        Write-Host $("Monkey {0}:" -f $Identifier)
        Write-Host $("  Starting items: {0}" -f $($this.Items -join ", "))
        if ($this.WorryOperator -eq '*') {
            $Op_String = "new = old * $($this.WorryElement)"
        } elseif ($this.WorryOperator -eq '+') {
            $Op_String = "new = old + $($this.WorryElement)"
        } elseif ($this.WorryOperator -eq '^') {
            $Op_String = "new = old * old"
        }
        Write-Host $("  Operation: {0}" -f $Op_String)
        Write-Host $("  Test: divisible by {0}" -f $this.TestDivisor)
        Write-Host $("    If true: throw to monkey {0}" -f $this.TrueTarget)
        Write-Host $("    If false: throw to monkey {0}" -f $this.FalseTarget)
        Write-Host ""
    }

    [void] CatchItem($ThrownItem) {
        $this.Items.Add($ThrownItem) > $null
    }

    [int64] TakeItem() {
        $this.InspectionCount = $this.InspectionCount + 1
        $TakenItem = $this.Items[0]
        $this.Items.RemoveAt(0)
        Write-Host $(" Monkey inspects an item with a worry level of {0}" -f $TakenItem)
        return $TakenItem
    }

    [int64] BoredWorryLevel($ItemWorryLevel) {
        $worry_total = [math]::Floor($ItemWorryLevel / 3)
        Write-Host $("    Monkey gets bored with item. Worry level is divided by 3 to {0}" -f $worry_total)
        return $worry_total
    }

    [int64] ModifyWorryLevel($ItemWorryLevel) {
        $worry_total = 0
        if ($this.WorryOperator -eq '*') {
            $worry_total = $ItemWorryLevel * $this.WorryElement
            Write-Host $("    Worry level is multiplied by {0} to {1}" -f $this.WorryElement, $worry_total)
        } elseif ($this.WorryOperator -eq '+') {
            $worry_total = $ItemWorryLevel + $this.WorryElement
            Write-Host $("    Worry level increases by {0} to {1}" -f $this.WorryElement, $worry_total)
        } elseif ($this.WorryOperator -eq '^') {
            $worry_total = $ItemWorryLevel * $ItemWorryLevel
            Write-Host $("    Worry level is multiplied by itself to {0}" -f $worry_total)
        }
        return $worry_total
    }

    [bool] TestWorryLevel($ItemWorryLevel) {
        $test_result = $false
        $result_txt = " not "
        if (($ItemWorryLevel % $this.TestDivisor) -eq 0) {
            $test_result = $true
            $result_txt = " "
        }
        Write-Host $("    Current worry level is{0}divisible by {1}" -f $result_txt, $this.TestDivisor)
        return $test_result
    }
}
#print an inventory of monkeys and their items
function Get-MonkeyInventory {
    param (
        $MonkeyArray
    )
    for ($m_index = 0; $m_index -lt $MonkeyArray.Count; $m_index++) {
        Write-Host $("Monkey {0}: {1}" -f $m_index, $($MonkeyArray[$m_index].Items -join ", "))
    }
    Write-Host ""
}
#get the monkey data from the file
$monkeys = [System.Collections.ArrayList]::new()
foreach ($m in $inp) {
    $split_m = $m.Split("`t")
    $m_items = $($split_m[1].Split(': ')[-1]).Split(", ")
    if ($split_m[2].Split(' ')[-1] -eq 'old') {
        $m_elem = ''
        $m_oper = '^'
    } else {
        $m_elem = $split_m[2].Split(' ')[-1]
    }
    if ($split_m[2].Split(' ')[-1] -eq 'old') {
        $m_elem = ''
    } else {
        $m_elem = $split_m[2].Split(' ')[-1]
        $m_oper = $split_m[2].Split(' ')[-2]
    }
    $m_test = $split_m[3].Split(' ')[-1]
    $m_tt = $split_m[4].Split(' ')[-1]
    $m_ft = $split_m[5].Split(' ')[-1]

    $monkeys.Add([Monkey]::new($m_items, $m_elem, $m_oper, $m_test, $m_tt, $m_ft)) > $null
}
#rounds loop
for ($round = 1; $round -le 20; $round++) {
    #process monkey loop
    for ($m = 0; $m -lt $monkeys.Count; $m++) {
        Write-Host $("Monkey {0}" -f $m)
        
        if ($monkeys[$m].Items.Count -gt 0) {
            while ($monkeys[$m].Items.Count -gt 0) {
                [int64]$wl = $monkeys[$m].TakeItem() # without the [int64] cast, I get an error later when trying to "floor" it
                $wl = $monkeys[$m].ModifyWorryLevel($wl)
                $wl = $monkeys[$m].BoredWorryLevel($wl)
                $reslt = $monkeys[$m].TestWorryLevel($wl)
                if ($reslt) {
                    Write-Host $("    Item with worry level {0} is thrown to monkey {1}" -f $wl, $monkeys[$m].TrueTarget)
                    $monkeys[$monkeys[$m].TrueTarget].CatchItem($wl)
                } else {
                    Write-Host $("    Item with worry level {0} is thrown to monkey {1}" -f $wl, $monkeys[$m].FalseTarget)
                    $monkeys[$monkeys[$m].FalseTarget].CatchItem($wl)
                }
            }
        } else {
            Write-Host "  This Monkey has no items"
        }
        Write-Host ""
    }
    #finish round and write results
    Write-Host "After round $round, the monkeys are holding items with these worry levels:"
    Get-MonkeyInventory $monkeys
}

for ($i = 0; $i -lt $monkeys.Count; $i++) {
    Write-Host $("Monkey {0} inspected items {1} times" -f $i, $monkeys[$i].InspectionCount)
}
Write-Host ""
$top_two = $($monkeys.InspectionCount | Sort-Object -Descending)[0..1] 
$p1_answer = $top_two[0] * $top_two[1]
Write-Host "Part 1 Answer is $p1_answer"