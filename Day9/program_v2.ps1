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
    Write-Host "Moving $Direction from coordiantes ($($RopeEnd.x),$($RopeEnd.y)) "
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
}

$inp = Get-Content ./Day9/small_input.txt

$movelist = $inp | Select-Object -Property @{Name='Direction';Expression={$_.Split(' ')[0]}},@{Name='Distance';Expression={$_.Split(' ')[1]}}
$RopeNodes = [System.Collections.ArrayList]::new()
$RopeNodes.Add(@{x=1;y=1})
$RopeNodes.Add(@{x=1;y=1})
$t=$RopeNodes[$RopeNodes.Count - 1]

$visited = [System.Collections.ArrayList]::new()
$visited.Add("$($t.x) $($t.y)")

foreach ($move in $movelist) {
    Write-Debug "Moving head $($move.Direction) - $($move.Distance) Times."
    foreach ($s in (1..$move.Distance)) {
        $oldTail = @{x=$($t.x);y=$($t.y)}
        for ($n = 0; $n -lt $RopeNodes.Count - 1; $n++) {
            Move-RopeEnd $RopeNodes[$n] $move.Direction
            $delta = Compare-RopePositions $RopeNodes[$n] $RopeNodes[$n+1]
            if (!(([Math]::Abs($delta.x) -lt 2) -and ([Math]::Abs($delta.y) -lt 2))) {
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
                if (($oldtail.x -ne $t.x) -and ($oldtail.y -ne $t.y)) {
                    Write-Host "Tail moved..."
                    $visited.Add("$($t.x) $($t.y)")
                } else {
                    Write-Host "Tail stayed put..."
                }
                Move-RopeEnd -RopeEnd $RopeNodes[$n + 1] -Direction $tdirection  
            }
        }
    } 
}

$poscount = $visited | Group-Object | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "Part 1 Answer is $poscount"

# A comparison that returns false if the difference between two ends is too far
# ([Math]::Abs($delta.x) -lt 2) -and ([Math]::Abs($delta.y) -lt 2)
# given that $delta = Compare-RopePositions $h $t