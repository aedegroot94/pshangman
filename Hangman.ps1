$dictionary = Get-Content "./dictionary.txt"

$gamestate = @{
    currentword = ""
    progress = ""
    incorrectguesses = 0
    alreadyguessed = @()

}

Function Get-Word($minlength, $maxlength) {
    $validword = ""
    while (!$validword) {
        $index = Get-Random -Minimum 0 -Maximum $($dictionary.Length - 1)
        If($dictionary[$index].Length -ge $minlength -and $dictionary[$index].Length -le $maxlength) {
           $validword = $dictionary[$index]
        }
    }
    return $validword  
}


Function New-Game($minlength = 4, $maxlength = 12) {
    $gamestate.currentword = Get-Word $minlength $maxlength
    $gamestate.progress = ""
    $gamestate.alreadyguessed = @()
    For($i=0;$i -lt $($gamestate.currentword.length);$i++) {
         $gamestate.progress += "_"
    }
    $gamestate.incorrectguesses = 0
}


Function Get-IndexesOfLetter($letter) {
    $indexes = @()
    For($i=0;$i -lt $($gamestate.currentword.length);$i++) {
         if ($gamestate.currentword[$i] -eq $letter) {
            $indexes += $i
         }
    }
    return $indexes

}

Function Update-Progress([array]$indexes, $letter) {
    $newstring = ""
    For($i=0;$i -lt $($gamestate.progress.length);$i++) {
        if($indexes.Contains($i)) {
            $newstring += $letter
        } else {
            $newstring += $gamestate.progress[$i]
        }
    }
    $gamestate.progress=$newstring
}

Function Get-Message($guessedright) {
    if ($guessedright) {
        return "Correct: $($gamestate.progress)"
    } else {
        return "False! You made $($gamestate.incorrectguesses) incorrect guesses so far. Watch out..."
    }
}

Function Guess($letter) {
    #if this is this first time someone Guesses, start the first game.
    if(!$gamestate.currentword) {
        New-Game
    }

    if($gamestate.alreadyGuessed.Contains($letter)) {
        $message = "You already guessed this letter! Pick another one."
    } else {
        $gamestate.alreadyGuessed += $letter
        $indexes = Get-IndexesOfLetter $letter
        if($indexes.Length -ge 1) {
            Update-Progress $indexes $letter
            $guessedright = $true
        } else {
            $guessedright = $false
            $gamestate.incorrectguesses++
            
        }
        if($gamestate.incorrectguesses -eq 5) {
            $message = "This was your fifth incorrect guess, game over! The word was $($gamestate.currentword). Starting a new game."
            New-Game 
        } else {
            $message = Get-Message $guessedright
        }
    }  
    return $message
}

