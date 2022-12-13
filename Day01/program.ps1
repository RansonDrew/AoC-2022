<# Replace all of this:
$calinv = Get-Content ./Day1/input.txt
# Make the input one long comma delimited string
$jncalinv = $calinv -join ","
# split that string at the blank lines (two commas together)
# this gives an array of comma separated values for each elf
$spcalinv = $jncalinv -split ",,"
With This: #>
$spcalinv = $(Get-Content ./Day01/input.txt -Raw).Split("`n`n")

$hi1 = 0
$hi2 = 0
$hi3 = 0

foreach($i in $spcalinv){
    $tot = 0
    # split each elf's items and add them to the total
    foreach($n in $i.Split("`n")){$tot += $n}
    # if the current value is higher than the highest recorded value
    # move the highest value down to the second highest variable
    # and move the second highest variable to the third highest spot
    # then replace the highest value.
    if($tot -gt $hi1){
        $hi3 = $hi2
        $hi2 = $hi1
        $hi1 = $tot
    }
}
$hitot = $hi1 + $hi2 + $hi3
Write-Host "The highest elf calories is $hi1"
Write-Host "The second highest elf calories is $hi2"
Write-Host "The third highest elf calories is $hi3"
Write-Host "The total of these three is $hitot"