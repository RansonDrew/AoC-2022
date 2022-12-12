$inp = Get-Content ./Day10/input.txt |
    Select-Object @{Name="Op";Expression={$_.Split(' ')[0]}},@{Name="Val";Expression={$_.Split(' ')[1]}}

$x = 1
$base_cycle = 20

$cycle = $base_cycle
$instruction_number = 1
$signal_sum = 0
foreach ($instruction in $inp) {
    $cycle = $cycle + 1
    if (($cycle % 40) -eq 0) {
        $signal_sum = $signal_sum + ($cycle - 20)*$x
    }
    if ($instruction.op -eq 'addx') {
        $cycle = $cycle + 1
        if (($cycle % 40) -eq 0) {
            $signal_sum = $signal_sum + ($cycle - 20)*$x
        }
        $x = $x + $instruction.Val
    }
    $instruction_number = $instruction_number + 1
}
Write-Host "Part 1 Answer = $signal_sum"

$crt_screen = [System.Collections.ArrayList]::new()
$x = 1
$cycle = 0
$crt_pos = 0
$sprite_pos = ($($x - 1)..$($x + 1))
$current_crt_row = ""
foreach ($instruction in $inp) {
    $cycle = $cycle + 1
    if ($sprite_pos -contains $crt_pos) {
        $current_crt_row += "#"
    } else {
        $current_crt_row += '.'
    }
    $crt_pos = $crt_pos + 1
    if (($cycle % 40) -eq 0) {
        $crt_screen.Add($current_crt_row) > $null
        $current_crt_row = ""
        $crt_pos = 0
    }
    if ($instruction.op -eq 'addx') {
        $cycle = $cycle + 1
        if ($sprite_pos -contains $crt_pos) {
            $current_crt_row += "#"
        } else {
            $current_crt_row += '.'
        }
        $crt_pos = $crt_pos + 1
        $x = $x + $instruction.Val
        $sprite_pos = ($($x - 1)..$($x + 1))
        if (($cycle % 40) -eq 0) {
            $crt_screen.Add($current_crt_row) > $null
            $current_crt_row = ""
            $crt_pos = 0
        }
    }
}
Write-Host "Part 2 Answer:"
foreach ($row in $crt_screen) {
    Write-Host $row
}