function Get-ItemPriority {
    param (
        $ItemCharacter
    )
    if ([byte][char]$ItemCharacter -lt 97) {        
        return [byte][char]$ItemCharacter - 38
    }
    else {
        return [byte][char]$ItemCharacter - 96
    }
}

function Split-SackRows {
    param (
        $RowText
    )
    return @(
                $($RowText.Substring(0,($RowText.Length / 2))).ToCharArray(),
                $($RowText.Substring(($RowText.Length / 2),($RowText.Length /2))).ToCharArray()
            )
}

function Find-CommonItem {
    param (
        $SackContents
    )
    $DividedSack = Split-SackRows $SackContents
    $FirstSack = $DividedSack[0]
    $SecondSack = $DividedSack[1]
    return Compare-Object -ReferenceObject $FirstSack -DifferenceObject $SecondSack -IncludeEqual -ExcludeDifferent | 
           Select-Object -ExpandProperty InputObject |
           Group-Object |
           Select-Object -ExpandProperty Name
}


$sacks = Get-Content ./Day3/input.txt
$p1total = 0
 foreach ($i in $sacks) {
     $p1total += Get-ItemPriority $(Find-CommonItem $i)
 }
 Write-Host "Part 1 Total is: $p1total"

$p2total = 0

for ($i = 0; $i -lt $sacks.Count; $i += 3) {
    $group1sack = $sacks[$i].ToCharArray()
    $group2sack = $sacks[$i + 1].ToCharArray()
    $group3sack = $sacks[$i + 2].ToCharArray()
    $comp1 = Compare-Object -ReferenceObject $group1sack -DifferenceObject $group2sack -IncludeEqual -ExcludeDifferent |
             Select-Object -ExpandProperty InputObject
    $comp2 = Compare-Object -ReferenceObject $comp1 -DifferenceObject $group3sack -IncludeEqual -ExcludeDifferent |
             Select-Object -ExpandProperty InputObject |
             Group-Object |
             Select-Object -ExpandProperty Name
    $p2total += Get-ItemPriority $comp2
}
Write-Host "Part 2 Toatal is: $p2total"