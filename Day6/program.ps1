$intext = Get-Content ./Day6/input.txt
  
$srchindx = 0
while (!($intext.Substring($srchindx,4) -match '^(?:([A-Za-z])(?!.*\1))*$')) {
    $srchindx += 1
}
Write-Host "Part 1 answer is $($srchindx + 4)"

$srchindx = 0
while (!($intext.Substring($srchindx,14) -match '^(?:([A-Za-z])(?!.*\1))*$')) {
    $srchindx += 1
}
Write-Host "Part 2 answer is $($srchindx + 14)"