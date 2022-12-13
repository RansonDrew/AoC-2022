# Create an array of empty stack objects based on the inoput text
function Initialize-CrateStacks {
    param (
        $CrateStackText
    )
    $stackobj = [System.Collections.ArrayList]::new()
    for ($i = 1; $i -le (($stackstxt[0].Length + 1) / 4); $i++) {
        $stackobj.Add([System.Collections.Stack]::new()) > $null
    }
    return $stackobj
}
# Fill the stack objects created with Initialize-CrateStacks
function Load-CrateStacks {
    param (
        $CrateStackText,
        $CrateStackObject
    )
    for ($stacksindex = $CrateStackText.count - 2; $stacksindex -ge 0; $stacksindex--) {
        $row = $CrateStackText[$stacksindex]
        $stacknum = 0
        for ($crateindex = 0; $crateindex -lt $row.Length; $crateindex += 4) {
            $cratename = $row.Substring($crateindex + 1, 1)
            if ($cratename -ne ' ') {
                $CrateStackObject[$stacknum].push($cratename)
            }
            $stacknum += 1
        }
    }
}

# Parse the input text into the stack drawing and the move list.
$stackstxt = $($(Get-Content ./Day05/input.txt) -join ',').Split(',,')[0].Split(',')
$movestxt  = $($(Get-Content ./Day05/input.txt) -join ',').Split(',,')[1].Split(',')

# Convert the move text rows into CSV text and load them into an object
for ($i = 0; $i -lt $movestxt.Count; $i++) {
    $movestxt[$i] = $($($movestxt[$i].Replace('move ', '')).Replace(' from ',',')).Replace(' to ',',') 
}
$moves = $movestxt | convertfrom-csv -Header "HowMany","FromStack","ToStack" 

# Part 1 Processing

# Create an arraylist object full of empty stacks and load them from the text drawing 
$stackarray = Initialize-CrateStacks -CrateStackText $stackstxt
Load-CrateStacks -CrateStackText $stackstxt -CrateStackObject $stackarray

# Use the HowMany property to pop a crate off the FromStack and onto the ToStack the correct number of times.
foreach ($move in $moves) {
    for ($i = 1; $i -le $move.HowMany; $i++) {
        $stackarray[$move.ToStack -1].push($stackarray[$move.FromStack -1].pop())
    }
}

# A little Powershell pipe-linig grabs the top entry from each stack and concatenates it into a single string.
$tops = $($stackarray | Select-Object @{Name='Tops';expression={$_.peek()}} | Select-Object -ExpandProperty Tops) -join ''

# Part 2 Processing

# Create an arraylist object full of empty stacks and load them from the text drawing
$stackarray = Initialize-CrateStacks -CrateStackText $stackstxt
Load-CrateStacks -CrateStackText $stackstxt -CrateStackObject $stackarray

# Use the HowMany property to pop a crate off the FromStack and add it to an arraylist the correct number of times.
# Reverse the array. Then, push the items from the array into the ToStack.
foreach ($move in $moves) {
    $cratechunk = [System.Collections.ArrayList]::new()
    for ($i = 1; $i -le $move.HowMany; $i++) {
        $cratechunk.Add($stackarray[$move.FromStack -1].pop()) > $null
    }
    $cratechunk.Reverse()
    $cratechunk | ForEach-Object -Process {$stackarray[$move.ToStack -1].push($_)}
}
# A little Powershell pipe-linig grabs the top entry from each stack and concatenates it into a single string.
$tops2 = $($stackarray | select @{Name='Tops';expression={$_.peek()}} | select -ExpandProperty Tops) -join ''


Write-Host "Part 1 answer is '$tops'."
Write-Host "Part 2 answer is '$tops2'."
