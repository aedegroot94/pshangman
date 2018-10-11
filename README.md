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