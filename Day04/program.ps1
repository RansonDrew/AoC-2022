$inp = Get-Content ./Day4/input.txt | Select-Object -Property @{Name='GroupOneRangeStart';expression={$($_.Split(',')[0]).Split('-')[0]}},
                                                              @{Name='GroupOneRangeEnd';expression={$($_.Split(',')[0]).Split('-')[1]}},  
                                                              @{Name='GroupTwoRangeStart';expression={$($_.Split(',')[1]).Split('-')[0]}},
                                                              @{Name='GroupTwoRangeEnd';expression={$($_.Split(',')[1]).Split('-')[1]}} 

$allincounter = 0
$olapcounter = 0
foreach ($i in $inp) {
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
    Write-Host $r1
    Write-Host $r2
    if ( $r1allin -or $r2allin){
        $allincounter += 1
        Write-Host " All-In - :) | Part-In - :)" -ForegroundColor Green
    } elseif ($cmp -gt 0) {
        Write-Host " All-In - :(" -NoNewline -ForegroundColor Red
        Write-Host " | " -NoNewline
        Write-Host "Part-In - :)" -ForegroundColor Green
    } else {
        Write-Host " All-In - :( | Part-In - :(" -ForegroundColor Red
    }
}
Write-Host "Part one answer is: $allincounter"
Write-Host "Part two answer is: $olapcounter"