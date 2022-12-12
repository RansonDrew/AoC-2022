# join by tabs and then split by double-tabs to find the blank lines
$inp = $($(Get-Content ./Day11/small_input.txt) -join "`t").Split("`t`t")

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

    [int] ModifyWorryLevel($ItemWorryLevel) {
        $worry_total = 0
        if ($this.WorryOperator -eq '*') {
            $worry_total = $ItemWorryLevel * $this.WorryElement
        } elseif ($this.WorryOperator -eq '+') {
            $worry_total = $ItemWorryLevel + $this.WorryElement
        } elseif ($this.WorryOperator -eq '^') {
            $worry_total = $ItemWorryLevel * $ItemWorryLevel
        }
        return $worry_total
    }


}

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

    $monkeys.Add([Monkey]::new($m_items, $m_elem, $m_oper, $m_test, $m_tt, $m_ft))
}