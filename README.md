# PowerShell hangman


A small PowerShell hangman game I made when I was bored, as a programming exercise.
In Windows PowerShell, execute the following script (replace HANGMAN_DIRECTORY by the hangman directory, for example c:\scripts\hangman):

```powershell
cd HANGMAN_DIRECTORY
import-module .\hangman.ps1
```

Make guesses by typing 'Guess' followed by the letter you want to guess (for example, r):

```powershell
Guess r
```

You can at any point start a new game by calling the New-Game function:

```powershell
New-Game
```

You can change the gamerules using the hangmanConfig function. You can give it the minimum and maximum amount of letters a word can have, and the amount of mistakes until a game over. You can set one or multiple parameters at a time:
```powershell
hangmanConfig -minletters 5
hangmanConfig -maxletters 10  -mistakes 3
hangmanConfig -minletters 4 -maxletters 9 -mistakes 6
```
Note: If minletters is higher than maxletters, minletters will be set equal to maxletters to avoid breaking the game.