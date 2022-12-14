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
        [int64]$TakenItem = $this.Items[0]
        $this.Items.RemoveAt(0)
        return $TakenItem
    }

    [int64] ModifyWorryLevel($ItemWorryLevel) {
        [int64]$worry_total = 0
        if ($this.WorryOperator -eq '*') {
            [int64]$worry_total = $ItemWorryLevel * $this.WorryElement
        } elseif ($this.WorryOperator -eq '+') {
            [int64]$worry_total = $ItemWorryLevel + $this.WorryElement
        } elseif ($this.WorryOperator -eq '^') {
            [int64]$worry_total = $ItemWorryLevel * $ItemWorryLevel
        }
        return $worry_total
    }

    [int64] ControlWorryLevel($ItemWorryLevel, $factor) {
        $worry_total = $ItemWorryLevel % $factor
        return $worry_total
    }

    [int64] BoredWorryLevel($ItemWorryLevel) {
        $worry_total = [math]::Floor($ItemWorryLevel / 3)
        return $worry_total
    }

    [bool] TestWorryLevel($ItemWorryLevel) {
        $test_result = $false
        if (($ItemWorryLevel % $this.TestDivisor) -eq 0) {
            $test_result = $true
        }
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

#============
#== PART 1 ==
#============

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
$common_factor = 1
foreach ($mono in $monkeys) {
    $common_factor = $common_factor * $mono.TestDivisor
}

#rounds loop
for ($round = 1; $round -le 20; $round++) {
    #process monkey loop
    $loopprogress = ($round / 100)
    if(($loopprogress % 1) -eq 0) {Write-Progress -Activity "Working on Part 2 Answer..." -Status "$loopprogress% Complete:" -PercentComplete $loopprogress}
    for ($m = 0; $m -lt $monkeys.Count; $m++) {
        if ($monkeys[$m].Items.Count -gt 0) {
            while ($monkeys[$m].Items.Count -gt 0) {
                [int64]$wl = $monkeys[$m].TakeItem() # without the [int64] cast, I get an error later when trying to "floor" it
                $wl = $monkeys[$m].ModifyWorryLevel($wl)
                $wl = $monkeys[$m].BoredWorryLevel($wl)
                $reslt = $monkeys[$m].TestWorryLevel($wl)
                if ($reslt) {
                    $monkeys[$monkeys[$m].TrueTarget].CatchItem($wl)
                } else {
                    $monkeys[$monkeys[$m].FalseTarget].CatchItem($wl)
                }
            }
        }
    }
}
Write-Progress -Activity "Working on Part 1 Answer..." -Completed

$top_two = $($monkeys.InspectionCount | Sort-Object -Descending)[0..1] 
$p1_answer = $top_two[0] * $top_two[1]
Write-Host "Part 1 Answer is $p1_answer"

#============
#== PART 2 ==
#============

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
$common_factor = 1
foreach ($mono in $monkeys) {
    $common_factor = $common_factor * $mono.TestDivisor
}

#rounds loop
for ($round = 1; $round -le 10000; $round++) {
    #process monkey loop
    $loopprogress = ($round / 100)
    if(($loopprogress % 1) -eq 0) {Write-Progress -Activity "Working on Part 2 Answer..." -Status "$loopprogress% Complete:" -PercentComplete $loopprogress}
    for ($m = 0; $m -lt $monkeys.Count; $m++) {
        if ($monkeys[$m].Items.Count -gt 0) {
            while ($monkeys[$m].Items.Count -gt 0) {
                [int64]$wl = $monkeys[$m].TakeItem()
                [int64]$wl = $monkeys[$m].ControlWorryLevel($wl, $common_factor)
                [int64]$wl = $monkeys[$m].ModifyWorryLevel($wl)
                $reslt = $monkeys[$m].TestWorryLevel($wl)
                if ($reslt) {
                    $monkeys[$monkeys[$m].TrueTarget].CatchItem($wl)
                } else {
                    $monkeys[$monkeys[$m].FalseTarget].CatchItem($wl)
                }
            }
        } 
    }
}
Write-Progress -Activity "Working on Part 2 Answer..." -Completed

$top_two = $($monkeys.InspectionCount | Sort-Object -Descending)[0..1] 
$p2_answer = $top_two[0] * $top_two[1]
Write-Host "Part 2 Answer is $p2_answer"
