function Compare-RopePositions {
    param (
        $ReferencePosition,
        $DifferencePosition
    )  
    return @{x=($ReferencePosition.x - $DifferencePosition.x);y=($ReferencePosition.y - $DifferencePosition.y)}
}

function Move-RopeEnd {
    [CmdletBinding()]
    param (
        $RopeEnd,
        $Direction
    )
    Write-Host "Moving $Direction from coordiantes ($($RopeEnd.x),$($RopeEnd.y)) " -NoNewline
    if ($Direction -eq 'R') {
        $RopeEnd.x = $RopeEnd.x + 1
    } elseif ($Direction -eq 'L'){
        $RopeEnd.x = $RopeEnd.x - 1
    } elseif ($Direction -eq 'U') {
        $RopeEnd.y = $RopeEnd.y + 1
    } elseif ($Direction -eq 'D') {
        $RopeEnd.y = $RopeEnd.y - 1
    } elseif ($Direction -eq "UL") {
        Move-RopeEnd $RopeEnd U
        Move-RopeEnd $RopeEnd L
    } elseif ($Direction -eq "UR") {
        Move-RopeEnd $RopeEnd U
        Move-RopeEnd $RopeEnd R
    } elseif ($Direction -eq "DL") {
        Move-RopeEnd $RopeEnd D
        Move-RopeEnd $RopeEnd L
    } elseif ($Direction -eq "DR") {
        Move-RopeEnd $RopeEnd D
        Move-RopeEnd $RopeEnd R
    }
    Write-Host " to coordinates ($($RopeEnd.x),$($RopeEnd.y))."
}

$inp = Get-Content ./Day9/input.txt

$movelist = $inp | Select-Object -Property @{Name='Direction';Expression={$_.Split(' ')[0]}},@{Name='Distance';Expression={$_.Split(' ')[1]}}
$h = @{x=1;y=1}
$t = @{x=1;y=1}

$visited = [System.Collections.ArrayList]::new()
$visited.Add("$($t.x) $($t.y)")

Write-Host "Head end starting position is ($($h.x),$($h.y))."

foreach ($move in $movelist) {
    Write-Host "---------------------------------"
    Write-Host "Moving head end $($move.Direction), $($move.Distance) times."
    Write-Host "---------------------------------"
    foreach ($s in (1..$move.Distance)) {
        Move-RopeEnd $h $move.Direction
        $delta = Compare-RopePositions $h $t
        if (!(([Math]::Abs($delta.x) -lt 2) -and ([Math]::Abs($delta.y) -lt 2))) {
            Write-Host "The tail is too far away!!!" -ForegroundColor Red
            $tdirection = ''
            if ([math]::Abs($delta.x) -eq 2) {
                if ($delta.x -eq 2) {
                    if ($delta.y -lt 0) {
                        $tdirection = 'DR'
                    } elseif ($delta.y -eq 0) {
                        $tdirection =  'R'
                    } else {
                        $tdirection = 'UR'
                    }
                } else {
                    if ($delta.y -lt 0) {
                        $tdirection = 'DL'
                    } elseif ($delta.y -eq 0) {
                        $tdirection =  'L'
                    } else {
                        $tdirection = 'UL'
                    }
                }
            } else {
                if ($delta.y -eq 2) {
                    if ($delta.x -lt 0) {
                        $tdirection = 'UL'
                    } elseif ($delta.x -eq 0) {
                        $tdirection =  'U'
                    } else {
                        $tdirection = 'UR'
                    }
                } else {
                    if ($delta.x -lt 0) {
                        $tdirection = 'DL'
                    } elseif ($delta.x -eq 0) {
                        $tdirection =  'D'
                    } else {
                        $tdirection = 'DR'
                    }
                }
            }
            Write-Host "**********************************************"
            Write-Host "Moving the tail $tdirection to catch up."
            Write-Host "**********************************************"
            Move-RopeEnd -RopeEnd $t -Direction $tdirection
            $visited.Add("$($t.x) $($t.y)")
            Write-Host "**********************************************"
            Write-Host "Done Moving tail"
            Write-Host "**********************************************"
        }
    }
    Write-Host "---------------------------------------"
    Write-Host "End of current move"
    Write-Host "---------------------------------------"    
}

Write-Host "Head end ending position is ($($h.x),$($h.y))."
Write-Host "Tail end ending position is ($($t.x),$($t.y))."
$poscount = $visited | Group-Object | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "Part 1 Answer is $poscount"

# A comparison that returns false if the difference between two ends is too far
# ([Math]::Abs($delta.x) -lt 2) -and ([Math]::Abs($delta.y) -lt 2)
# given that $delta = Compare-RopePositions $h $t