$inp = Get-Content ./Day10/input.txt |
    Select-Object @{Name="Op";Expression={$_.Split(' ')[0]}},@{Name="Val";Expression={$_.Split(' ')[1]}}

function Draw-SpritePosition {
    param (
        $SpriteArray
    )
    $sprite_crt_row = ""
    for ($i = 0; $i -lt 40; $i++) {
        if ($SpriteArray -contains $i) {
            $sprite_crt_row += "#"
        
        } else {
        $sprite_crt_row += "."
        }
    }
    return $sprite_crt_row
}

$x = 1
$base_cycle = 20

$cycle = $base_cycle
$instruction_number = 1
$signal_sum = 0
foreach ($instruction in $inp) {
    $cycle = $cycle + 1
    #Write-Debug "Instruction number: $instruction_number"
    #Write-Debug "   Operation is $($instruction.Op) - Cycle is $($cycle - 20)"
    if (($cycle % 40) -eq 0) {
        #Write-Debug " *** Key Cycle is $($cycle - 20) Operation is '$($instruction.Op)'***"
        #Write-Debug " $($cycle - 20) * $x = $($($cycle - 20)*$x)"
        Write-Host "Cycle: $($cycle - 20) * Register: $x = Signal Strength: $($($cycle - 20)*$x)"
        $signal_sum = $signal_sum + ($cycle - 20)*$x
    }
    if ($instruction.op -eq 'addx') {
        $cycle = $cycle + 1
        #Write-Debug "   Operation is $($instruction.Op) - Cycle is $($cycle - 20)"
        if (($cycle % 40) -eq 0) {
            #Write-Debug " *** Key Cycle is $($cycle - 20) Operation is '$($instruction.Op)'***"
            #Write-Debug " $($cycle - 20) * $x = $($($cycle - 20)*$x)"
            Write-Host "Cycle: $($cycle - 20) * Register: $x = Signal Strength: $($($cycle - 20)*$x)"
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