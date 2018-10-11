$dictionary = Get-Content "./dictionary.txt"

$gamestate = @{
    currentword = ""
    progress = ""
    incorrectguesses = 0
    alreadyguessed = @()

}

$config = @{
    minletters = 4
    maxletters = 12
    mistakes = 5
}

Function hangmanConfig([int]$minletters = $config.minletters, [int]$maxletters = $config.maxletters, [int]$mistakes = $config.mistakes) {
    if($minletters -gt $maxletters) {
        $minletters=$maxletters
    }
    $config.minletters = $minletters
    $config.maxletters = $maxletters
    $config.mistakes = $mistakes
}


Function Get-Word() {
    $validword = ""
    while (!$validword) {
        $index = Get-Random -Minimum 0 -Maximum $($dictionary.Length - 1)
        If($dictionary[$index].Length -ge $config.minletters -and $dictionary[$index].Length -le $config.maxletters) {
           $validword = $dictionary[$index]
        }
    }
    return $validword  
}


Function New-Game() {
    $gamestate.currentword = Get-Word
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

Function Guess([string]$guess) {
    #if this is this first time someone Guesses, start the first game.
    if(!$gamestate.currentword) {
        New-Game
    }

    #if the given string is longer than one letter, only the first one will be used
    $letter = $guess[0]

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
        if($gamestate.incorrectguesses -eq $config.mistakes) {
            $message = "You made $($gamestate.incorrectguesses) incorrect guesses, game over! The word was $($gamestate.currentword). Starting a new game."
            New-Game 
        } elseif (!$gamestate.progress.Contains("_")) {
            $message = "You won! The word was $($gamestate.currentword). Starting a new game."
            New-Game 
        } else {
            $message = Get-Message $guessedright
        }
    }  
    return $message
}

