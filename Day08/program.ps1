#read the input from a text file
$inp = Get-Content ./Day08/input.txt

function Test-Direction {
    <#A function to test the visibility and generate the scenic score for a direction
      It returns a boolean for visibility and a scenicscore number.
      Given the problem, it should probably test all directions and send a single
      as well as the four direction scenic scores #>
    param (
        $TreeGrid, #an n by n object
        $TreeRow, #zero-based
        $TreeColumn, #zero-based
        [ValidateSet('right','left','up','down')]$Direction
    )
    $gridheigth = $TreeGrid.Count - 1 #zero-based
    $gridwidth = $TreeGrid[0].Length - 1 #zero-based
    $TreeValue = $TreeGrid[$TreeRow][$TreeColumn]
    $visible = $true #unless we figure out otherwise, it's visible
    $scenicscore = 0 
    #ughh... in my defense, I only wanted to run this function enough times
    #to say whether any one direction was blocked.
    #then came part two...
    if ($Direction -eq 'left') {
        $CheckRow = $TreeColumn - 1
        while (($CheckRow -ge 0) -and ($visible)) {
            $scenicscore = $scenicscore + 1
            if ($TreeValue -le $TreeGrid[$TreeRow][$CheckRow]) {
                $visible = $false
            }
            $CheckRow = $CheckRow - 1
        }
    } elseif ($Direction -eq 'right') {
        $CheckRow = $TreeColumn + 1
        while (($CheckRow -le $gridwidth) -and ($visible)) {
            $scenicscore = $scenicscore + 1
            if ($TreeValue -le $TreeGrid[$TreeRow][$CheckRow]) {
                $visible = $false
            }
            $CheckRow = $CheckRow + 1
        }
    } elseif ($Direction -eq 'up') {
        $CheckColumn = $TreeRow - 1
        while (($CheckColumn -ge 0) -and ($visible)) {
            $scenicscore = $scenicscore + 1
            if ($TreeValue -le $TreeGrid[$CheckColumn][$TreeColumn]) {
                $visible = $false
            }
            $CheckColumn = $CheckColumn - 1
        }
    } elseif ($Direction -eq 'down') {
        $CheckColumn = $TreeRow + 1
        while (($CheckColumn -le $gridheigth) -and ($visible)) {
            $scenicscore = $scenicscore + 1
            if ($TreeValue -le $TreeGrid[$CheckColumn][$TreeColumn]) {
                $visible = $false
            }
            $CheckColumn = $CheckColumn + 1
        }
    }
    return @{TreeVisible=$visible;ScenicScore=$scenicscore}
}
#turns out I didn't need to do this. the $inp object was already addressable on two axes
#but, I started out thinking an array of arrays and what not
[System.Collections.ArrayList]$grid = $inp
$columncount = $grid[0].Length
$rowcount = $grid.Count
$visible_trees = 2 * $columncount + (2 * $rowcount - 4)
$scenescore = 0
for ($inner_row = 1; $inner_row -lt $rowcount - 1; $inner_row++) {
    for ($inner_column = 1; $inner_column -lt $columncount - 1; $inner_column++) {
        #ugh.... I'm way too lazy to replace this with a single function call, but I know I could (should?)
        $upview = Test-Direction -TreeGrid $grid -TreeRow $inner_row -TreeColumn $inner_column -Direction up
        $downview = Test-Direction -TreeGrid $grid -TreeRow $inner_row -TreeColumn $inner_column -Direction down
        $leftview = Test-Direction -TreeGrid $grid -TreeRow $inner_row -TreeColumn $inner_column -Direction left
        $rightview = Test-Direction -TreeGrid $grid -TreeRow $inner_row -TreeColumn $inner_column -Direction right
        $visibilty = $upview.TreeVisible -or $downview.TreeVisible -or $leftview.TreeVisible -or $rightview.TreeVisible
        $currentscenescore = $upview.ScenicScore * $downview.ScenicScore * $leftview.ScenicScore * $rightview.ScenicScore
        if ($visibilty) {
            $visible_trees = $visible_trees + 1
        }
        if ($scenescore -lt $currentscenescore){
            $scenescore = $currentscenescore
        }
    }
}
Write-Host "Part 1 Answer is $visible_trees"
Write-Host "Part 2 Answer $scenescore"

