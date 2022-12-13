function ConvertFrom-RopeNode {
    param (
        $RopeNode
    )
    return "[$($RopeNode.x) , $($RopeNode.y)]"    
}

function Compare-RopePositions {
    param (
        $ReferencePosition,
        $DifferencePosition
    )  
    return @{x=($ReferencePosition.x - $DifferencePosition.x);y=($ReferencePosition.y - $DifferencePosition.y)}
}

function Test-RopeNodeTooFar {
    param (
        $RopeDelta # this is the return value of the Compare-RopePositions function
    )
    # I'm asking if they are too far apart and something needs to happen
    # returns $true if the second node needs to 'catch up'
    if (([Math]::Abs($RopeDelta.x) -lt 2) -and ([Math]::Abs($RopeDelta.y) -lt 2)) {
        return $false
    } else {
        return $true
    }
}

function Get-ChaseDirection {
    param (
        $RopeDelta
    )
    $returndirection = ''
    if ([math]::Abs($RopeDelta.x) -eq 2) {
        if ($RopeDelta.x -eq 2) {
            if ($RopeDelta.y -lt 0) {
                $returndirection = 'DR'
            } elseif ($RopeDelta.y -eq 0) {
                $returndirection =  'R'
            } else {
                $returndirection = 'UR'
            }
        } else {
            if ($RopeDelta.y -lt 0) {
                $returndirection = 'DL'
            } elseif ($RopeDelta.y -eq 0) {
                $returndirection =  'L'
            } else {
                $returndirection = 'UL'
            }
        }
    } else {
        if ($RopeDelta.y -eq 2) {
            if ($RopeDelta.x -lt 0) {
                $returndirection = 'UL'
            } elseif ($RopeDelta.x -eq 0) {
                $returndirection =  'U'
            } else {
                $returndirection = 'UR'
            }
        } else {
            if ($RopeDelta.x -lt 0) {
                $returndirection = 'DL'
            } elseif ($RopeDelta.x -eq 0) {
                $returndirection =  'D'
            } else {
                $returndirection = 'DR'
            }
        }
    }
    return $returndirection
}
function Move-RopeEnd {
    [CmdletBinding()]
    param (
        $RopeEnd,
        $Direction
    )
    #Write-Host "Moving $Direction from coordiantes ($($RopeEnd.x),$($RopeEnd.y)) "
    if ($Direction -eq 'R') {
        $RopeEnd.x = $RopeEnd.x + 1
    } elseif ($Direction -eq 'L'){
        $RopeEnd.x = $RopeEnd.x - 1
    } elseif ($Direction -eq 'U') {
        $RopeEnd.y = $RopeEnd.y + 1
    } elseif ($Direction -eq 'D') {
        $RopeEnd.y = $RopeEnd.y - 1
    } elseif ($Direction -eq "UL") {
        $RopeEnd.x = $RopeEnd.x - 1
        $RopeEnd.y = $RopeEnd.y + 1
    } elseif ($Direction -eq "UR") {
        $RopeEnd.x = $RopeEnd.x + 1
        $RopeEnd.y = $RopeEnd.y + 1
    } elseif ($Direction -eq "DL") {
        $RopeEnd.x = $RopeEnd.x - 1
        $RopeEnd.y = $RopeEnd.y - 1
    } elseif ($Direction -eq "DR") {
        $RopeEnd.x = $RopeEnd.x + 1
        $RopeEnd.y = $RopeEnd.y - 1
    }
    return @{x=$RopeEnd.x;y=$RopeEnd.y}   
}

$sw = [System.Diagnostics.Stopwatch]::StartNew()
$inp = Get-Content ./Day9/input.txt

$movelist = $inp | Select-Object -Property @{Name='Direction';Expression={$_.Split(' ')[0]}},@{Name='Distance';Expression={$_.Split(' ')[1]}}
$RopeNodes = [System.Collections.ArrayList]::new()
$RopeNodes.Add(@{x=1;y=1}) > $null
$RopeNodes.Add(@{x=1;y=1}) > $null
$t = ConvertFrom-RopeNode $RopeNodes[$RopeNodes.count - 1]

$visited = [System.Collections.ArrayList]::new()
$visited.Add($t) > $null
$loopcount = 1
foreach ($move in $movelist) {
    $loopprogress = $loopcount / $movelist.Count * 100
    if(($loopprogress % 1) -eq 0) {Write-Progress -Activity "Making Moves..." -Status "$loopprogress% Complete:" -PercentComplete $loopprogress}
    foreach ($s in (1..$move.Distance)) {
        # iterate through an object for each step inthe distance variable
        # move the head node ($ropenodes[0])
        #Write-Debug "   Moving Head Node from $(ConvertFrom-RopeNode $RopeNodes[0]) to $(ConvertFrom-RopeNode $(Move-RopeEnd $RopeNodes[0] $Move.Direction))"
        Move-RopeEnd $RopeNodes[0] $Move.Direction > $null
        for ($n = 1; $n -lt $RopeNodes.Count; $n++) {
            # for each subsequent node in the rope, check if it needs to be moved and move it if necessary
            # find the difference in coordinates 
            $delta = Compare-RopePositions $RopeNodes[$n - 1] $RopeNodes[$n]
            # check if this node needs to move
            if($(Test-RopeNodeTooFar $delta)){
                #Write-Debug "      Moving Node $n from $(ConvertFrom-RopeNode $RopeNodes[$n]) to $(ConvertFrom-RopeNode $(Move-RopeEnd $RopeNodes[$n] $(Get-ChaseDirection $delta)))"
                Move-RopeEnd $RopeNodes[$n] $(Get-ChaseDirection $delta) > $null
            }            
        }
        # at this point, all nodes should be checked and moved
        # check to see if the tail moved
        if ($(ConvertFrom-RopeNode $RopeNodes[$RopeNode.Count - 1]) -ne $t) {
            # add it to the $visited array
            #Write-Debug "      *** TAIL MOVED! ***"
            if (!($visited.Contains($(ConvertFrom-RopeNode $RopeNodes[$RopeNode.Count - 1])))) {
                $visited.Add($(ConvertFrom-RopeNode $RopeNodes[$RopeNode.Count - 1])) > $null    
            }
            $t = ConvertFrom-RopeNode $RopeNodes[$RopeNodes.count - 1]
        }
    } 
    $loopcount = $loopcount + 1
}

Write-Progress -Activity "Making Moves..." -Completed
$poscount = $visited.Count
Write-Host "Part 1 Answer is $poscount"
Write-Host "Part 1 took $($sw.ElapsedMilliseconds) Milliseconds to run."

# part 2 - because I'm too tired of this puzzle to spend more time functionalizing the logic
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$RopeNodes = [System.Collections.ArrayList]::new()
foreach ($i in (1..10)) {
    $RopeNodes.Add(@{x=1;y=1}) > $null    
}

$t = ConvertFrom-RopeNode $RopeNodes[$RopeNodes.count - 1]

$visited = [System.Collections.ArrayList]::new()
$visited.Add($t) > $null

$loopcount = 1
foreach ($move in $movelist) {
    $loopprogress = $loopcount / $movelist.Count * 100
    if(($loopprogress % 1) -eq 0) {Write-Progress -Activity "Making Moves..." -Status "$loopprogress% Complete:" -PercentComplete $loopprogress}
    foreach ($s in (1..$move.Distance)) {
        # iterate through an object for each step inthe distance variable
        # move the head node ($ropenodes[0])
        #Write-Debug "   Moving Head Node from $(ConvertFrom-RopeNode $RopeNodes[0]) to $(ConvertFrom-RopeNode $(Move-RopeEnd $RopeNodes[0] $Move.Direction))"
        Move-RopeEnd $RopeNodes[0] $Move.Direction > $null
        for ($n = 1; $n -lt $RopeNodes.Count; $n++) {
            # for each subsequent node in the rope, check if it needs to be moved and move it if necessary
            # find the difference in coordinates 
            $delta = Compare-RopePositions $RopeNodes[$n - 1] $RopeNodes[$n]
            # check if this node needs to move
            if($(Test-RopeNodeTooFar $delta)){
                #Write-Debug "      Moving Node $n from $(ConvertFrom-RopeNode $RopeNodes[$n]) to $(ConvertFrom-RopeNode $(Move-RopeEnd $RopeNodes[$n] $(Get-ChaseDirection $delta)))"
                Move-RopeEnd $RopeNodes[$n] $(Get-ChaseDirection $delta) > $null
            }            
        }
        # at this point, all nodes should be checked and moved
        # check to see if the tail moved
        if ($(ConvertFrom-RopeNode $RopeNodes[$RopeNode.Count - 1]) -ne $t) {
            # add it to the $visited array
            #Write-Debug "      *** TAIL MOVED! ***"
            if (!($visited.Contains($(ConvertFrom-RopeNode $RopeNodes[$RopeNode.Count - 1])))) {
                $visited.Add($(ConvertFrom-RopeNode $RopeNodes[$RopeNode.Count - 1])) > $null    
            }
            $t = ConvertFrom-RopeNode $RopeNodes[$RopeNodes.count - 1]
        }
    } 
    $loopcount = $loopcount + 1
}
Write-Progress -Activity "Making Moves..." -Completed

$poscount = $visited.Count
Write-Host "Part 2 Answer is $poscount"
Write-Host "Part 2 took $($sw.ElapsedMilliseconds) Milliseconds to run."