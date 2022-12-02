


function get-rndscore {
    param (
        $o_choice,
        $my_choice
    )
    $x = 1 #Rock
    $y = 2 #Paper
    $z = 3 #Scissors
    $win = 6
    $draw = 3
    
    if($o_choice -eq 'A'){
        if ($my_choice -eq 'Y') {
            # Win :)
            return ($y + $win)
        }
        elseif ($my_choice -eq 'X') {
            # Draw :|
            return ($x + $draw)
        }
        else {
            # Loss :(
            return $z
        }
    }
    elseif ($o_choice -eq 'B') {
        if ($my_choice -eq 'Z') {
            # Win :)
            return ($z + $win)
        }
        elseif ($my_choice -eq 'Y') {
            # Draw :|
            return ($y + $draw)
        }
        else {
            # Loss :(
            return $x
        }
    }
    else {
        if ($my_choice -eq 'X') {
            # Win :)
            return ($x + $win)
        }
        elseif ($my_choice -eq 'Z') {
            # Draw :|
            return ($z + $draw)
        }
        else {
            # Loss :(
            return $y
        }
    }
}

function get-neededchoice {
    param (
        $o_choice,
        $e_result
    )
    if ($o_choice -eq 'A') {
        if ($e_result -eq 'Z') {
            return 'Y'
        }
        elseif ($e_result -eq 'X'){
            return 'Z'
        }
        else {
            return 'X'
        }
    }
    elseif ($o_choice -eq 'B') {
        if ($e_result -eq 'Z') {
            return 'Z'
        }
        elseif ($e_result -eq 'X'){
            return 'X'
        }
        else {
            return 'Y'
        }
    }
    else {
        if ($e_result -eq 'Z') {
            return 'X'
        }
        elseif ($e_result -eq 'X'){
            return 'Y'
        }
        else {
            return 'Z'
        }
    }
}


$rnds = get-content ./Day2/input.txt

$p1score = 0

foreach($r in $rnds){
    $rndscore = 0
    $oppo = $r.Split(' ')[0]
    $me = $r.Split(' ')[1]
    $rndscore = get-rndscore -o_choice $oppo -my_choice $me
    $p1score += $rndscore
}


$p2score = 0
$p2rnds = $rnds | Select-Object -Property @{name='opchoice';expression={$_.Split(' ')[0]}},
                                          @{name='exresult';expression={$_.Split(' ')[1]}},
                                          @{name='mychoice';expression={get-neededchoice -o_choice $($_.Split(' ')[0]) -e_result $($_.Split(' ')[1])}}


foreach ($pr in $p2rnds) {
    $p2rndscore = 0
    $p2oppo = $pr.opchoice
    $p2me = $pr.mychoice
    $p2rndscore = get-rndscore -o_choice $p2oppo -my_choice $p2me
    $p2score += $p2rndscore
}


Write-Host "Total for Part 1 is $p1score"
Write-Host "Total for Part 2 is $p2score"