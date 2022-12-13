$inp = Get-Content ./Day04/input.txt | Select-Object -Property @{Name='GroupOneRangeStart';expression={$($_.Split(',')[0]).Split('-')[0]}},
                                                               @{Name='GroupOneRangeEnd';expression={$($_.Split(',')[0]).Split('-')[1]}},  
                                                               @{Name='GroupTwoRangeStart';expression={$($_.Split(',')[1]).Split('-')[0]}},
                                                               @{Name='GroupTwoRangeEnd';expression={$($_.Split(',')[1]).Split('-')[1]}} 

$allincounter = 0
$olapcounter = 0
$loopcounter = 1
foreach ($i in $inp) {
    $loopprogress = ($loopcounter / $inp.Count) * 100
    if (($loopprogress % 1) -eq 0) {Write-Progress -Activity "Processing Loop..." -PercentComplete $loopprogress -Status "Processed $loopprogress% of Loop:"}
    $r1 = $i.GroupOneRangeStart..$i.GroupOneRangeEnd
    $r2 = $i.GroupTwoRangeStart..$i.GroupTwoRangeEnd
    $cmp = Compare-Object -ReferenceObject $r1 -DifferenceObject $r2 -IncludeEqual -ExcludeDifferent | 
           Select-Object -ExpandProperty InputObject
    if ($cmp -eq $null) {
        $cmp = @(0)
    } else {
        $olapcounter += 1
    }
    $r1allin = $(Compare-Object -ReferenceObject $cmp -DifferenceObject $r1).Length -eq 0
    $r2allin = $(Compare-Object -ReferenceObject $cmp -DifferenceObject $r2).Length -eq 0 
    if ( $r1allin -or $r2allin){
        $allincounter += 1
    }
    $loopcounter = $loopcounter + 1
}
Write-Progress -Activity "Processing Loop..." -Completed
Write-Host "Part one answer is: $allincounter"
Write-Host "Part two answer is: $olapcounter"