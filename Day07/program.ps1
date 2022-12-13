$sw = [System.Diagnostics.Stopwatch]::StartNew()

# I hate how slowly this runs, but it works. There definitely has to be a more efficient way to index the directory object array,
# but I wasted a lot of time this morning playing around with classes and then abandoning them as too complicated.
$inp = Get-Content ./Day7/input.txt

$dirs = [System.Collections.ArrayList]::new()
$currentdirectory = ''

foreach ($line in $inp) {
    $parseline = $line.split(' ')
    if ($parseline[0] -eq '$') { #this is a command of some sort
        if ($parseline[1] -eq 'cd'){ #this is a change directory command
            if ($parseline[2] -ne '..'){ #if we are not moving up one directory
                if ($parseline[2] -eq '/') { #if we are changing to the root directory
                    $currentdirectory = 'root'
                } else {
                    $currentdirectory += "/$($parseline[2])"
                }
            } else { #moving up one directory
                $currentdirectory = $currentdirectory.Substring(0,$currentdirectory.LastIndexOf('/'))
            }
        }
        if ($($dirs | Where-Object Name -EQ $currentdirectory).Count -lt 1) { #if it's not in the directory objects array, add it
            $newdirobject = New-Object -TypeName pscustomobject
            Add-Member -InputObject $newdirobject -MemberType NoteProperty -Name "Name" -Value $currentdirectory
            Add-Member -InputObject $newdirobject -MemberType NoteProperty -Name "Size" -Value 0
            $dirs.Add($newdirobject) > $null
        }        
    } else { #it's not a command it must be a directory or a file
        if ($parseline[0] -ne 'dir'){ #if it's a file add the size to the current directory and each directory above it
            $updatedirsize = $dirs | Where-Object Name -EQ $currentdirectory
            $updatedirsize.Size += $parseline[0]
            $walkdir = $currentdirectory
            $cutlength = $walkdir.LastIndexOf('/')
            while ($cutlength -gt -1){
                $walkdir = $walkdir.Substring(0,$cutlength)
                $updatedirsize = $dirs | Where-Object Name -EQ $walkdir
                $updatedirsize.Size += $parseline[0]
                $cutlength = $walkdir.LastIndexOf('/')
            }
        }
    }
}
#filter the directory object array to those less than 100000 and use the Measure-Object cmdlet to sum the size values
$p1answer = $($dirs | Where-Object Size -lt 100000) | Measure-Object -Property Size -Sum | Select-Object -ExpandProperty Sum
Write-Host "Part 1 answer is: $p1answer"

#find out how much freespace we have and how much we need
$freespace = 70000000 - $dirs[0].Size
$targetvalue = 30000000 - $freespace

#filter the directory object array to those greater than or equal to the target value, sor it by size and capture the size value of the smallest one
$p2answer = $dirs | Where-Object Size -ge $targetvalue | Sort-Object -Property size | Select-Object -First 1 | Select-Object -ExpandProperty Size
Write-Host "Part 2 answer is $p2answer"

Write-Host "This Script took $($sw.ElapsedMilliseconds) Milliseconds to run."