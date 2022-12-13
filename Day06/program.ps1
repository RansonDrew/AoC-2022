$intext = Get-Content ./Day6/input.txt
  
$srchindx = 0
# starting at the 0th index grab string of four and compare it to a regex searching for all unique charaters
# stop if you find the group of four unique characters or you hit the end of the text
while (!($intext.Substring($srchindx,4) -match '^(?:([a-z])(?!.*\1))*$')) {
    $srchindx += 1
}
Write-Host "Part 1 answer is $($srchindx + 4)"

$srchindx = 0
while (!($intext.Substring($srchindx,14) -match '^(?:([a-z])(?!.*\1))*$')) {
    $srchindx += 1
}
Write-Host "Part 2 answer is $($srchindx + 14)"