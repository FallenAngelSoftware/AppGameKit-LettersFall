// "logic.agc"...

remstart
---------------------------------------------------------------------------------------------------

    Copyright 2022 Team "www.FallenAngelSoftware.com"

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software
    and associated documentation files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or
    substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
    AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
---------------------------------------------------------------------------------------------------
remend

function LoadDictionaryLetterFile ( )
	letters as String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	DictionaryString[DictionaryLetterLoading].load( "/media/dictionary/"+Mid(letters, DictionaryLetterLoading+1,1)+"-Words.json" )
endfunction

//------------------------------------------------------------------------------------------------------------

function CheckSelectedLettersForWord ( )
	if (SelectedLetterWordIndex > 1)
		lastIndex as integer
		wordFound as integer
		CurrentWordSelected = ""
		index as integer
		for index = 0 to SelectedLetterWordIndex
			CurrentWordSelected = CurrentWordSelected + SelectedLetters[index]
		next index
	
		letterToCheck as integer
		if (SelectedLetters[0] = "A")
			letterToCheck = 0
		elseif (SelectedLetters[0] = "B")
			letterToCheck = 1
		elseif (SelectedLetters[0] = "C")
			letterToCheck = 2
		elseif (SelectedLetters[0] = "D")
			letterToCheck = 3
		elseif (SelectedLetters[0] = "E")
			letterToCheck = 4
		elseif (SelectedLetters[0] = "F")
			letterToCheck = 5
		elseif (SelectedLetters[0] = "G")
			letterToCheck = 6
		elseif (SelectedLetters[0] = "H")
			letterToCheck = 7
		elseif (SelectedLetters[0] = "I")
			letterToCheck = 8
		elseif (SelectedLetters[0] = "J")
			letterToCheck = 9
		elseif (SelectedLetters[0] = "K")
			letterToCheck = 10
		elseif (SelectedLetters[0] = "L")
			letterToCheck = 11
		elseif (SelectedLetters[0] = "M")
			letterToCheck = 12
		elseif (SelectedLetters[0] = "N")
			letterToCheck = 13
		elseif (SelectedLetters[0] = "O")
			letterToCheck = 14
		elseif (SelectedLetters[0] = "P")
			letterToCheck = 15
		elseif (SelectedLetters[0] = "Q")
			letterToCheck = 16
		elseif (SelectedLetters[0] = "R")
			letterToCheck = 17
		elseif (SelectedLetters[0] = "S")
			letterToCheck = 18
		elseif (SelectedLetters[0] = "T")
			letterToCheck = 19
		elseif (SelectedLetters[0] = "U")
			letterToCheck = 20
		elseif (SelectedLetters[0] = "V")
			letterToCheck = 21
		elseif (SelectedLetters[0] = "W")
			letterToCheck = 22
		elseif (SelectedLetters[0] = "X")
			letterToCheck = 23
		elseif (SelectedLetters[0] = "Y")
			letterToCheck = 24
		elseif (SelectedLetters[0] = "Z")
			letterToCheck = 25
		endif
	
		wordFound = -1
		for index = 0 to 9999999
			if (DictionaryString[letterToCheck, index] = "1")
				lastIndex = index
				index = 99999999
			else
				if ( CompareString(DictionaryString[letterToCheck, index], CurrentWordSelected, 1, -1) > 0 )
					PlaySoundEffect(6)
					CorrectWordTileAndCharAlpha = 255
					GameStatus = ClearingWord
					CheckWordRed = 0
					CheckWordGreen = 255
					CheckWordBlue = 0
					SetSpriteColorRed( Icon[82], CheckWordRed )
					SetSpriteColorGreen( Icon[82], CheckWordGreen )
					SetSpriteColorBlue( Icon[82], CheckWordBlue )
					CheckWordColorTimer = 25
					wordFound = 1
				endif
			endif
		next index
	
		if (wordFound = -1)
			PlaySoundEffect(7)
			CheckWordRed = 255
			CheckWordGreen = 0
			CheckWordBlue = 0
			SetSpriteColorRed( Icon[82], CheckWordRed )
			SetSpriteColorGreen( Icon[82], CheckWordGreen )
			SetSpriteColorBlue( Icon[82], CheckWordBlue )
			CheckWordColorTimer = 25
		endif
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function SetupForNewGame ( )
indexY as integer
indexX as integer
randomLetter as integer

	QuitGame = FALSE

	FingerPlayfieldX = -1
	FingerPlayfieldY = -1

	GameIsPlaying = TRUE
	
	GameOverTimer = -1
	
	textIndex as integer
	for indexY = 0 to 18
		for indexX = 0 to 10
			Playfield[indexX, indexY] = "1"
			PlayfieldLetterTextIndex[indexX, indexY] = CurrentMinTextIndex
			inc CurrentMinTextIndex, 26
		next indexX
	next indexY

	startFill as integer
	startFill = 10
	if (SecretCodeCombined = 9876) then startFill = 10
		
	for indexY = startFill to 17
		for indexX = 0 to 10
			randomLetter = Random( 0, 25 )
			if     (randomLetter =  0)
				Playfield[indexX, indexY] = "A"
			elseif (randomLetter =  1)
				Playfield[indexX, indexY] = "B"
			elseif (randomLetter =  2)
				Playfield[indexX, indexY] = "C"
			elseif (randomLetter =  3)
				Playfield[indexX, indexY] = "D"
			elseif (randomLetter =  4)
				Playfield[indexX, indexY] = "E"
			elseif (randomLetter =  5)
				Playfield[indexX, indexY] = "F"
			elseif (randomLetter =  6)
				Playfield[indexX, indexY] = "G"
			elseif (randomLetter =  7)
				Playfield[indexX, indexY] = "H"
			elseif (randomLetter =  8)
				Playfield[indexX, indexY] = "I"
			elseif (randomLetter =  9)
				Playfield[indexX, indexY] = "J"
			elseif (randomLetter = 10)
				Playfield[indexX, indexY] = "K"
			elseif (randomLetter = 11)
				Playfield[indexX, indexY] = "L"
			elseif (randomLetter = 12)
				Playfield[indexX, indexY] = "M"
			elseif (randomLetter = 13)
				Playfield[indexX, indexY] = "N"
			elseif (randomLetter = 14)
				Playfield[indexX, indexY] = "O"
			elseif (randomLetter = 15)
				Playfield[indexX, indexY] = "P"
			elseif (randomLetter = 16)
				Playfield[indexX, indexY] = "Q"
			elseif (randomLetter = 17)
				Playfield[indexX, indexY] = "R"
			elseif (randomLetter = 18)
				Playfield[indexX, indexY] = "S"
			elseif (randomLetter = 19)
				Playfield[indexX, indexY] = "T"
			elseif (randomLetter = 20)
				Playfield[indexX, indexY] = "U"
			elseif (randomLetter = 21)
				Playfield[indexX, indexY] = "V"
			elseif (randomLetter = 22)
				Playfield[indexX, indexY] = "W"
			elseif (randomLetter = 23)
				Playfield[indexX, indexY] = "X"
			elseif (randomLetter = 24)
				Playfield[indexX, indexY] = "Y"
			elseif (randomLetter = 25)
				Playfield[indexX, indexY] = "Z"
			endif
		next indexX
	next indexY

	Playfield[ 0, 14] = "J"
	Playfield[ 1, 10] = "O"
	Playfield[ 3, 15] = "Y"
	Playfield[ 4, 12] = "F"
	Playfield[ 6, 10] = "U"
	Playfield[ 7, 13] = "L"
	Playfield[ 8, 14] = "L"
	Playfield[10, 10] = "Y"

	Score = 0
	Level = 0
	Bombs = 1

	if (StartingLevel > 0)
		Level = StartingLevel
	endif

	if (SecretCodeCombined = 9876)
		Score = 9748930
		Level = 9
		Bombs = 5
	elseif (SecretCodeCombined > 7999 and SecretCodeCombined < 8010)
		Level = SecretCode[3]
		Bombs = 15
	endif

	GamePaused = -1	

	SelectedLetterWordIndex = -1
	for indexX = 0 to 11
		SelectedLettersTextIndex[indexX] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, " ", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (  ( (31/2)+9 ) + (indexX)*31 - 31  ), 509, 3 )
		SelectedLettersPlayfieldX[indexX] = -1
		SelectedLettersPlayfieldY[indexX] = -1
		SelectedLetters[indexX] = "1"
	next indexX

	FallingLettersCount = 1
	if (Level > 5)
		FallingLettersCount = 3
	elseif (Level > 2)
		FallingLettersCount = 2
	endif

	FallingLettersPlayfieldX[0] = 0
	FallingLettersPlayfieldY[0] = 2

	if (FallingLettersCount > 1)
		FallingLettersPlayfieldX[1] = 0
		FallingLettersPlayfieldY[1] = 1
	endif

	if (FallingLettersCount > 2)
		FallingLettersPlayfieldX[2] = 0
		FallingLettersPlayfieldY[2] = 0
	endif

	FallingLettersScreenY[0] = 0 - ( 31*FallingLettersPlayfieldY[0] )-(31*2)
	FallingLettersScreenY[1] = -9999
	FallingLettersScreenY[2] = -9999

	if (FallingLettersCount > 1)
		FallingLettersScreenY[1] = 0 -( 31*FallingLettersPlayfieldY[1] )-(31*3)
	endif
	
	if (FallingLettersCount > 2)
		FallingLettersScreenY[2] = 0 - ( 31*FallingLettersPlayfieldY[2] )-(31*4)
	endif

	FallingLettersScreenYstep[0] = 0
	FallingLettersScreenYstep[1] = 0
	FallingLettersScreenYstep[2] = 0
	
	FallingLettersLetter[0] = GetRandomLetter()
	FallingLettersLetter[1] = GetRandomLetter()
	FallingLettersLetter[2] = GetRandomLetter()

	SetSpritePositionByOffset( FallingLettersTileSprite[0], (31/2)+9, FallingLettersScreenY[0] )
	SetSpritePositionByOffset( FallingLettersTileSprite[1], (31/2)+9, FallingLettersScreenY[1] )
	SetSpritePositionByOffset( FallingLettersTileSprite[2], (31/2)+9, FallingLettersScreenY[2] )

	FallingLettersTextIndex[0] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, FallingLettersLetter[0], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9, FallingLettersScreenY[0], 3 )
	FallingLettersTextIndex[1] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, FallingLettersLetter[1], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9, FallingLettersScreenY[1], 3 )
	FallingLettersTextIndex[2] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, FallingLettersLetter[2], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9, FallingLettersScreenY[2], 3 )

	NextFallingIsBomb = 0
	ExplosionScale = 0
	ExplosionAlpha = 0
	
	MouseButtonLeftJustClicked = -1
	
	CurrentWordSelected = ""
	
	GameStatus = PlayingGame
	
	CorrectWordTileAndCharAlpha = 255
	
	BombMeterScaleX = .01
	SetSpriteScaleByOffset( BombMeterSprite, BombMeterScaleX, 1 )
	
	CheckWordRed = 255
	CheckWordGreen = 255
	CheckWordBlue = 255
	CheckWordColorTimer = 0
	
	FallingLetterSpeed[0] = 2
	FallingLetterSpeed[1] = 8
	FallingLetterSpeed[2] = 4
	FallingLetterSpeed[3] = 2
	FallingLetterSpeed[4] = 8
	FallingLetterSpeed[5] = 4
	
	FallingLetterDecimalCounter = 0
	
	LevelAdvanceCounter = 0
	WonGame = FALSE
	
	if ( SecretCodeCombined = 9876 or (SecretCodeCombined > 7999 and SecretCodeCombined < 8010) )
		LevelAdvanceCounter = ( 13*(Level+1) )-1 rem 24

		if (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
			PlayNewMusic(5, 1)
		endif

		PlaySoundEffect(9)
	endif
	
	PlayfieldIsDirty = TRUE
	
	if (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
		if (Level = 0 or Level = 1)
			PlayNewMusic(1, 1)
		elseif (Level = 2 or Level = 3)
			PlayNewMusic(2, 1)
		elseif (Level = 4 or Level = 5)
			PlayNewMusic(3, 1)
		elseif (Level = 6 or Level = 7)
			PlayNewMusic(4, 1)
		elseif (Level = 8 or Level = 9)
			PlayNewMusic(5, 1)
		endif
	else
		PlayNewMusic(6, 1)
	endif

	FallingLettersAfterBombMovePlayfieldX = -1
	
	LaskKeyboardKey = -1
endfunction

//------------------------------------------------------------------------------------------------------------

function SetupForNextLevel ( )
indexY as integer
indexX as integer
randomLetter as integer

	FingerPlayfieldX = -1
	FingerPlayfieldY = -1

	GameIsPlaying = TRUE
	
	GameOverTimer = -1

	GamePaused = -1	

	SelectedLetterWordIndex = -1
	for indexX = 0 to 11
		SelectedLettersTextIndex[indexX] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, " ", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (  ( (31/2)+9 ) + (indexX)*31 - 31  ), 509, 3 )
		SelectedLettersPlayfieldX[indexX] = -1
		SelectedLettersPlayfieldY[indexX] = -1
		SelectedLetters[indexX] = "1"
	next indexX

	FallingLettersCount = 1
	if (Level > 5)
		FallingLettersCount = 3
	elseif (Level > 2)
		FallingLettersCount = 2
	endif

	FallingLettersPlayfieldX[0] = 0
	FallingLettersPlayfieldY[0] = 2

	if (FallingLettersCount > 1)
		FallingLettersPlayfieldX[1] = 0
		FallingLettersPlayfieldY[1] = 1
	endif

	if (FallingLettersCount > 2)
		FallingLettersPlayfieldX[2] = 0
		FallingLettersPlayfieldY[2] = 0
	endif

	FallingLettersScreenY[0] = 0 - ( 31*FallingLettersPlayfieldY[0] )-(31*2)
	FallingLettersScreenY[1] = -9999
	FallingLettersScreenY[2] = -9999

	if (FallingLettersCount > 1)
		FallingLettersScreenY[1] = 0 -( 31*FallingLettersPlayfieldY[1] )-(31*3)
	endif
	
	if (FallingLettersCount > 2)
		FallingLettersScreenY[2] = 0 - ( 31*FallingLettersPlayfieldY[2] )-(31*4)
	endif

	FallingLettersScreenYstep[0] = 0
	FallingLettersScreenYstep[1] = 0
	FallingLettersScreenYstep[2] = 0
	
	FallingLettersLetter[0] = GetRandomLetter()
	FallingLettersLetter[1] = GetRandomLetter()
	FallingLettersLetter[2] = GetRandomLetter()

	SetSpritePositionByOffset( FallingLettersTileSprite[0], (31/2)+9, FallingLettersScreenY[0] )
	SetSpritePositionByOffset( FallingLettersTileSprite[1], (31/2)+9, FallingLettersScreenY[1] )
	SetSpritePositionByOffset( FallingLettersTileSprite[2], (31/2)+9, FallingLettersScreenY[2] )

	FallingLettersTextIndex[0] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, FallingLettersLetter[0], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9, FallingLettersScreenY[0], 3 )
	FallingLettersTextIndex[1] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, FallingLettersLetter[1], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9, FallingLettersScreenY[1], 3 )
	FallingLettersTextIndex[2] = CreateAndInitializeOutlinedText( FALSE, CurrentMinTextIndex, FallingLettersLetter[2], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9, FallingLettersScreenY[2], 3 )

	NextFallingIsBomb = 0
	ExplosionScale = 0
	ExplosionAlpha = 0
	
	MouseButtonLeftJustClicked = -1
	
	CurrentWordSelected = ""
	
	GameStatus = PlayingGame
	
	CorrectWordTileAndCharAlpha = 255
	
	BombMeterScaleX = .01
	SetSpriteScaleByOffset( BombMeterSprite, BombMeterScaleX, 1 )
	
	CheckWordRed = 255
	CheckWordGreen = 255
	CheckWordBlue = 255
	CheckWordColorTimer = 0
	
	FallingLetterSpeed[0] = 2
	FallingLetterSpeed[1] = 8
	FallingLetterSpeed[2] = 4
	FallingLetterSpeed[3] = 2
	FallingLetterSpeed[4] = 8
	FallingLetterSpeed[5] = 4
	
	FallingLetterDecimalCounter = 0
	
	LevelAdvanceCounter = 0
	WonGame = FALSE
	
	if ( SecretCodeCombined = 9876 or (SecretCodeCombined > 7999 and SecretCodeCombined < 8010) )
		LevelAdvanceCounter = ( 13*(Level+1) )-1 rem 24

		if (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
			PlayNewMusic(5, 1)
		endif

		PlaySoundEffect(9)
	endif
	
	PlayfieldIsDirty = TRUE
	
	if (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
		if (Level = 0)
			PlayNewMusic(1, 1)
		elseif (Level = 2)
			PlayNewMusic(2, 1)
		elseif (Level = 4)
			PlayNewMusic(3, 1)
		elseif (Level = 6)
			PlayNewMusic(4, 1)
		elseif (Level = 8)
			PlayNewMusic(5, 1)
		endif
	endif

	FallingLettersAfterBombMovePlayfieldX = -1
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayPlayfield ( )
	if (PlayfieldIsDirty = FALSE) then exitfunction

	screenY as integer
	screenX as integer
	screenY = 0-(31*2)
	screenX = (31/2)+9
	indexY as integer
	indexX as integer
	for indexY = 0 to 18
		for indexX = 0 to 10
			if (Playfield[indexX, indexY] <> "1")
				if ( GetSpriteColorRed(LetterTileSprite[indexX, indexY]) = 255 )
					SetSpritePositionByOffset( LetterTileSprite[indexX, indexY], screenX, screenY )
					
					textIndex as integer
					for textIndex = (PlayfieldLetterTextIndex[indexX, indexY]) to (PlayfieldLetterTextIndex[indexX, indexY]+26)
						if GetTextExists(textIndex) then DeleteText( textIndex ) 
					next textIndex
					PlayfieldLetterTextIndex[indexX, indexY] = CreateAndInitializeOutlinedText( FALSE, PlayfieldLetterTextIndex[indexX, indexY], Playfield[indexX, indexY], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, screenX, screenY+1, 3 )
				else
					SetSpritePositionByOffset( LetterTileSprite[indexX, indexY], screenX, screenY )
					SetSpriteColorAlpha( LetterTileSprite[indexX, indexY], CorrectWordTileAndCharAlpha )
					
					for textIndex = (PlayfieldLetterTextIndex[indexX, indexY]) to (PlayfieldLetterTextIndex[indexX, indexY]+26)
						if GetTextExists(textIndex) then DeleteText( textIndex ) 
					next textIndex
					PlayfieldLetterTextIndex[indexX, indexY] = CreateAndInitializeOutlinedText( FALSE, PlayfieldLetterTextIndex[indexX, indexY], Playfield[indexX, indexY], 999, 30, 0, 0, 0, CorrectWordTileAndCharAlpha, 232, 166, 0, 1, screenX, screenY+1, 3 )
				endif

				if (OnMobile = TRUE and FingerPlayfieldX > -1 and FingerPlayfieldY > -1)
					if (indexX = FingerPlayfieldX and indexY = FingerPlayfieldY)					
						if GetTextExists(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY])
							SetTextDepth(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY], 2)
							SetTextPosition(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY], GetTextX(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY]), screenY-80) //GetTextY(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY])+80-18)
						endif
					endif
				endif
			else
				if GetTextExists(textIndex) then PlayfieldLetterTextIndex[indexX, indexY] = CreateAndInitializeOutlinedText( FALSE, PlayfieldLetterTextIndex[indexX, indexY], " ", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, screenX, screenY+1, 3 )
			endif
			inc screenX, 31
		next indexX
		
		inc screenY, 31
		screenX = (31/2)+9
	next indexY

	screenX = (31/2)+9
	for indexX = 0 to (SelectedLetterWordIndex)
		SetSpritePositionByOffset( SelectedLettersTileSprite[indexX], screenX, 509 )
		SetSpriteColorAlpha( SelectedLettersTileSprite[indexX], CorrectWordTileAndCharAlpha )
		SetTextColorAlpha( SelectedLettersTextIndex[indexX+1], CorrectWordTileAndCharAlpha )
		inc screenX, 31
	next indexX

	PlayfieldIsDirty = FALSE
endfunction

//------------------------------------------------------------------------------------------------------------

function ApplyGravityToPlayfield ( )
indexY as integer
indexX as integer
returnValue as integer
returnValue = FALSE
	for indexY = 17 to 1 step -1
		for indexX = 0 to 10
			if (Playfield[indexX, indexY] = "1" and Playfield[indexX, indexY-1] <> "1")
				Playfield[indexX, indexY] = Playfield[indexX, indexY-1]
				Playfield[indexX, indexY-1] = "1"
				SetText(PlayfieldLetterTextIndex[indexX, indexY-1], " ")
				SetSpritePositionByOffset( LetterTileSprite[indexX, indexY-1], -9999, -9999 )
				returnValue = TRUE
			endif
		next indexX
	next indexY
endfunction(returnValue)

//------------------------------------------------------------------------------------------------------------

function EraseCorrectWord ( )
	FingerPlayfieldX = -1
	FingerPlayfieldY = -1

	indexX as integer
	inc LevelAdvanceCounter, SelectedLetterWordIndex
	countToLevelAdvance as integer
	countToLevelAdvance = ( 13*(Level+1) )
	if (countToLevelAdvance > 300) then countToLevelAdvance = 300
	if ( LevelAdvanceCounter > countToLevelAdvance or SecretCodeCombined = 1234)
		inc Level, 1

		if ( (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode) and Level < 10 )
			if (Level = 5) then ScreenFadeStatus = FadingToBlack
			NewLevelTextAlphaDirection = 1
		else
			NewLevelTextAlphaDirection = 1
		endif		
		
		if (Level < 10) then LevelSkip[GameMode] = Level
		
		if (Level = 3 or Level = 6)
			inc FallingLettersCount, 1

			if (FallingLettersCount > 1)
				FallingLettersLetter[1] = GetRandomLetter()
				FallingLettersPlayfieldX[1] = FallingLettersPlayfieldX[0]
				FallingLettersPlayfieldY[1] = FallingLettersPlayfieldY[0]-1
				FallingLettersScreenY[1] = 0 -( 31*FallingLettersPlayfieldY[1] )-(31*3)
				if ( GetTextExists(FallingLettersTextIndex[1]) ) then DeleteText(FallingLettersTextIndex[1])
				CreateAndInitializeOutlinedText( FALSE, FallingLettersTextIndex[1], FallingLettersLetter[1], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9+(FallingLettersPlayfieldX[0]*31), FallingLettersScreenY[1], 3 )
			endif
			
			if (FallingLettersCount > 2)
				FallingLettersLetter[2] = GetRandomLetter()
				FallingLettersPlayfieldX[2] = FallingLettersPlayfieldX[0]
				FallingLettersPlayfieldY[2] = FallingLettersPlayfieldY[0]-2
				FallingLettersScreenY[2] = 0 - ( 31*FallingLettersPlayfieldY[2] )-(31*4)
				if ( GetTextExists(FallingLettersTextIndex[2]) ) then DeleteText(FallingLettersTextIndex[2])
				CreateAndInitializeOutlinedText( FALSE, FallingLettersTextIndex[2], FallingLettersLetter[2], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, (31/2)+9+(FallingLettersPlayfieldX[1]*31), FallingLettersScreenY[2], 3 )
			endif

			PlayfieldIsDirty = TRUE
		endif
		
		if (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
			if (Level = 2)
				PlayNewMusic(2, 1)
			elseif (Level = 4)
				PlayNewMusic(3, 1)
			elseif (Level = 6)
				PlayNewMusic(4, 1)
			elseif (Level = 8)
				PlayNewMusic(5, 1)
			elseif (Level = 10)
				WonGame = TRUE
				GameOverTimer = 150
			endif
		endif
		
		if (Level < 10)
			if ( Level = 5 and (GameMode = ChildStoryMode or GameMode = TeenStoryMode or AdultStoryMode) )
				
			else
				PlaySoundEffect(9)
			endif
		elseif (GameMode = ChildNeverEndMode or GameMode = TeenNeverEndMode or GameMode = AdultNeverEndMode)
			PlaySoundEffect(9)		
		endif
				
		LevelAdvanceCounter = 0
	endif
	
	bombMeterIncrease as float
	bombMeterIncrease = 0
	for indexX = 0 to SelectedLetterWordIndex
		if (SelectedLetters[indexX] = "A")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "B")
			Score = Score + ( (Level+1) * (30) )
			bombMeterIncrease = (.005 * 3)
		elseif (SelectedLetters[indexX] = "C")
			Score = Score + ( (Level+1) * (30) )
			bombMeterIncrease = (.005 * 3)
		elseif (SelectedLetters[indexX] = "D")
			Score = Score + ( (Level+1) * (20) )
			bombMeterIncrease = (.005 * 2)
		elseif (SelectedLetters[indexX] = "E")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "F")
			Score = Score + ( (Level+1) * (40) )
			bombMeterIncrease = (.005 * 4)
		elseif (SelectedLetters[indexX] = "G")
			Score = Score + ( (Level+1) * (20) )
			bombMeterIncrease = (.005 * 2)
		elseif (SelectedLetters[indexX] = "H")
			Score = Score + ( (Level+1) * (40) )
			bombMeterIncrease = (.005 * 4)
		elseif (SelectedLetters[indexX] = "I")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "J")
			Score = Score + ( (Level+1) * (80) )
			bombMeterIncrease = (.005 * 8)
		elseif (SelectedLetters[indexX] = "K")
			Score = Score + ( (Level+1) * (50) )
			bombMeterIncrease = (.005 * 5)
		elseif (SelectedLetters[indexX] = "L")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "M")
			Score = Score + ( (Level+1) * (30) )
			bombMeterIncrease = (.005 * 3)
		elseif (SelectedLetters[indexX] = "N")
			Score = Score + ( (Level+1) * (1) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "O")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "P")
			Score = Score + ( (Level+1) * (30) )
			bombMeterIncrease = (.005 * 3)
		elseif (SelectedLetters[indexX] = "Q")
			Score = Score + ( (Level+1) * (100) )
			bombMeterIncrease = (.005 * 10)
		elseif (SelectedLetters[indexX] = "R")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "S")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "T")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "U")
			Score = Score + ( (Level+1) * (10) )
			bombMeterIncrease = (.005 * 1)
		elseif (SelectedLetters[indexX] = "V")
			Score = Score + ( (Level+1) * (40) )
			bombMeterIncrease = (.005 * 4)
		elseif (SelectedLetters[indexX] = "W")
			Score = Score + ( (Level+1) * (40) )
			bombMeterIncrease = (.005 * 4)
		elseif (SelectedLetters[indexX] = "X")
			Score = Score + ( (Level+1) * (80) )
			bombMeterIncrease = (.005 * 8)
		elseif (SelectedLetters[indexX] = "Y")
			Score = Score + ( (Level+1) * (40) )
			bombMeterIncrease = (.005 * 4)
		elseif (SelectedLetters[indexX] = "Z")
			Score = Score + ( (Level+1) * (100) )
			bombMeterIncrease = (.005 * 10)
		endif

		index as float
		for index = 0 to bombMeterIncrease step .01
			if (BombMeterScaleX < .99)
				inc BombMeterScaleX, .01
			else
				BombMeterScaleX = 0
				inc Bombs, 1
				PlaySoundEffect(8)
			endif

			SetSpriteScaleByOffset( BombMeterSprite, BombMeterScaleX, 1 )
		next index		

		SetSpriteColor( LetterTileSprite[ SelectedLettersPlayfieldX[indexX], SelectedLettersPlayfieldY[indexX] ], 255, 255, 255, 255 )
		SetSpritePositionByOffset( LetterTileSprite[ SelectedLettersPlayfieldX[indexX], SelectedLettersPlayfieldY[indexX] ], -9999, -9999 )
		SetSpritePositionByOffset( SelectedLettersTileSprite[indexX], -9999, -9999 )
		SetText(SelectedLettersTextIndex[indexX+1], " ")
		Playfield[ SelectedLettersPlayfieldX[indexX], SelectedLettersPlayfieldY[indexX] ] = "1"
		SelectedLettersPlayfieldX[indexX] = -1
		SelectedLettersPlayfieldY[indexX] = -1
		SelectedLetters[indexX] = "1"
	next indexX

	IconScreenX[3] = -9999
	IconScreenY[3] = -9999
	SetSpritePositionByOffset( Icon[80], IconScreenX[3], IconScreenY[3] )

	SelectedLetterWordIndex = -1
endfunction

//------------------------------------------------------------------------------------------------------------

function EraseChosenLetters ( )
	indexX as integer
	for indexX = 0 to SelectedLetterWordIndex
		SetSpriteColor( LetterTileSprite[ SelectedLettersPlayfieldX[indexX], SelectedLettersPlayfieldY[indexX] ], 255, 255, 255, 255 )
		SetSpritePositionByOffset( SelectedLettersTileSprite[indexX], -9999, -9999 )
		SetText(SelectedLettersTextIndex[indexX+1], " ")
		SelectedLettersPlayfieldX[indexX] = -1
		SelectedLettersPlayfieldY[indexX] = -1
		SelectedLetters[indexX] = "1"
	next indexX
	
	IconScreenX[3] = -9999
	IconScreenY[3] = -9999
	SetSpritePositionByOffset( Icon[80], IconScreenX[3], IconScreenY[3] )
	
	SelectedLetterWordIndex = -1

	FingerPlayfieldX = -1
	FingerPlayfieldY = -1
endfunction

//------------------------------------------------------------------------------------------------------------

function GetNumberOfVowels ( )
returnValue as integer
indexY as integer
indexX as integer
	returnValue = 0
	for indexY = 0 to 18
		for indexX = 0 to 10
			if (Playfield[indexX, indexY] = "A")
				inc returnValue, 1
			elseif (Playfield[indexX, indexY] = "E")
				inc returnValue, 1
			elseif (Playfield[indexX, indexY] = "I")
				inc returnValue, 1
			elseif (Playfield[indexX, indexY] = "O")
				inc returnValue, 1
			elseif (Playfield[indexX, indexY] = "U")
				inc returnValue, 1
			endif
		next indexX
	next indexY
endfunction(returnValue)

//------------------------------------------------------------------------------------------------------------

function GetRandomLetter ( )
randomLetter as integer
letter as string

	if ( GetNumberOfVowels() < 4+3 )
		randomLetter = Random(0, 4)
		if     (randomLetter =  0)
			letter = "A"
		elseif     (randomLetter =  1)
			letter = "E"
		elseif     (randomLetter =  2)
			letter = "I"
		elseif     (randomLetter =  3)
			letter = "O"
		elseif     (randomLetter =  4)
			letter = "U"
		endif
	else
		randomLetter = Random( 0, 25 )
		if     (randomLetter =  0)
			letter = "A"
		elseif (randomLetter =  1)
			letter = "B"
		elseif (randomLetter =  2)
			letter = "C"
		elseif (randomLetter =  3)
			letter = "D"
		elseif (randomLetter =  4)
			letter = "E"
		elseif (randomLetter =  5)
			letter = "F"
		elseif (randomLetter =  6)
			letter = "G"
		elseif (randomLetter =  7)
			letter = "H"
		elseif (randomLetter =  8)
			letter = "I"
		elseif (randomLetter =  9)
			letter = "J"
		elseif (randomLetter = 10)
			letter = "K"
		elseif (randomLetter = 11)
			letter = "L"
		elseif (randomLetter = 12)
			letter = "M"
		elseif (randomLetter = 13)
			letter = "N"
		elseif (randomLetter = 14)
			letter = "O"
		elseif (randomLetter = 15)
			letter = "P"
		elseif (randomLetter = 16)
			letter = "Q"
		elseif (randomLetter = 17)
			letter = "R"
		elseif (randomLetter = 18)
			letter = "S"
		elseif (randomLetter = 19)
			letter = "T"
		elseif (randomLetter = 20)
			letter = "U"
		elseif (randomLetter = 21)
			letter = "V"
		elseif (randomLetter = 22)
			letter = "W"
		elseif (randomLetter = 23)
			letter = "X"
		elseif (randomLetter = 24)
			letter = "Y"
		elseif (randomLetter = 25)
			letter = "Z"
		endif
	endif
endfunction letter

//------------------------------------------------------------------------------------------------------------

function BlowUpSomeOfPlayfield ( )
	indexX as integer
	indexY as integer
	for indexY = (BombHitPlayfieldY-3) to (BombHitPlayfieldY+4)
		for indexX = (BombHitPlayfieldX-3) to (BombHitPlayfieldX+3)
			if (indexY > -1 and indexY < 19 and indexX > -1 and indexX < 11)
				if (indexY = BombHitPlayfieldY+4 and indexX = BombHitPlayfieldX-3)
					
				elseif (indexY = BombHitPlayfieldY+4 and indexX = BombHitPlayfieldX+3)
					
				else
					Playfield[indexX, indexY] = "1"
					SetSpritePositionByOffset( LetterTileSprite[indexX, indexY], -9999, -9999 )
					if GetTextExists(PlayfieldLetterTextIndex[indexX, indexY]) then SetText(PlayfieldLetterTextIndex[indexX, indexY], " ")
				endif
			endif
		next indexX
	next indexY
endfunction

//------------------------------------------------------------------------------------------------------------

function AddFallingLettersToPlayfield ( playfieldX, playfieldY )
	screenY as integer
	screenX as integer
	screenY = 0-(31*2)-1
	screenX = (31/2)+9
	indexY as integer
	indexX as integer
	for indexY = 0 to 18
		for indexX = 0 to 10
			if (playfieldX = indexX and playfieldY = indexY)
				SetSpritePositionByOffset( LetterTileSprite[indexX, indexY], screenX, screenY )
			
				textIndex as integer
				textIndex = (PlayfieldLetterTextIndex[indexX, indexY])
				if GetTextExists(textIndex) then DeleteText( textIndex ) 
				PlayfieldLetterTextIndex[indexX, indexY] = CreateAndInitializeOutlinedText( FALSE, PlayfieldLetterTextIndex[indexX, indexY], Playfield[indexX, indexY], 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, screenX, screenY+1, 3 )

				exitfunction
			endif
			inc screenX, 31
		next indexX
		
		inc screenY, 31
		screenX = (31/2)+9
	next indexY
endfunction

//------------------------------------------------------------------------------------------------------------

function SetupNextLetters ( )
	letterFalling as integer
	for letterFalling = 0 to (FallingLettersCount-1)
		dec FallingLettersPlayfieldY[letterFalling], 1
		
		Playfield[ FallingLettersPlayfieldX[letterFalling], FallingLettersPlayfieldY[letterFalling] ] = FallingLettersLetter[letterFalling]
		AddFallingLettersToPlayfield(FallingLettersPlayfieldX[letterFalling], FallingLettersPlayfieldY[letterFalling])

		if (letterFalling = 0)
			if (FallingLettersAfterBombMovePlayfieldX > -1)					
				FallingLettersPlayfieldX[letterFalling] = FallingLettersAfterBombMovePlayfieldX
			endif
			FallingLettersPlayfieldY[letterFalling] = 2
			FallingLettersScreenY[letterFalling] = (-45+(FallingLettersPlayfieldY[letterFalling]*31)-(31*2))
		elseif (letterFalling = 1)
			if (FallingLettersAfterBombMovePlayfieldX > -1)					
				FallingLettersPlayfieldX[letterFalling] = FallingLettersAfterBombMovePlayfieldX
			endif
			FallingLettersPlayfieldY[letterFalling] = 1
			FallingLettersScreenY[letterFalling] = (-45+(FallingLettersPlayfieldY[letterFalling]*31)-(31*3))
		elseif (letterFalling = 2)
			if (FallingLettersAfterBombMovePlayfieldX > -1)					
				FallingLettersPlayfieldX[letterFalling] = FallingLettersAfterBombMovePlayfieldX
			endif
			FallingLettersPlayfieldY[letterFalling] = 0
			FallingLettersScreenY[letterFalling] = (-45+(FallingLettersPlayfieldY[letterFalling]*31)-(31*4))
		endif
		
		if (FallingLettersPlayfieldX[letterFalling] < 10)
			inc FallingLettersPlayfieldX[letterFalling], 1
		else
			FallingLettersPlayfieldX[letterFalling] = 0
		endif

		SetTextX( FallingLettersTextIndex[letterFalling], (31/2)+9+(FallingLettersPlayfieldX[letterFalling]*31) )
		SetTextY(FallingLettersTextIndex[letterFalling], FallingLettersScreenY[letterFalling]-17)

		FallingLettersLetter[letterFalling] = GetRandomLetter()
		SetText( FallingLettersTextIndex[letterFalling], FallingLettersLetter[letterFalling] )

		SetSpritePositionByOffset( FallingLettersTileSprite[letterFalling], (31/2)+9+((FallingLettersPlayfieldX[letterFalling])*31), FallingLettersScreenY[letterFalling] )			
	next letterFalling
	
	PlayfieldIsDirty = TRUE
	DisplayPlayfield()	
endfunction

//------------------------------------------------------------------------------------------------------------

function CheckForLowLetters ( )
indexY as integer
indexX as integer
playfieldHeight as integer
indexYtwo as integer
indexXtwo as integer
index as integer

	playfieldHeight = 0
	for indexY = 0 to 18
		for indexX = 0 to 10
			if (Playfield[indexX, indexY] <> "1")
				playfieldHeight = indexY
				indexX = 11
				indexY = 19
			endif
		next indexX
	next indexY

	if ( PlayfieldHeight > (18-5) )
		PlaySoundEffect(13)
		Score = Score + ( 1000 * (Level + 1) )

		if (SelectedLetterWordIndex > -1)
			for index = 0 to SelectedLetterWordIndex
				SetSpriteColor( LetterTileSprite[SelectedLettersPlayfieldX[index], SelectedLettersPlayfieldY[index]], 255, 255, 255, 255 )
			next index
		endif

		for indexYtwo = 1 to 18
			for indexXtwo = 0 to 10
				Playfield[indexXtwo, indexYtwo-1] = Playfield[indexXtwo, indexYtwo]
			next indexXTwo
		next indexYtwo
		
		for indexXtwo = 0 to 10
			Playfield[indexXtwo, 17] = GetRandomLetter()
		next indexXtwo

		PlayfieldIsDirty = TRUE
		DisplayPlayfield()

		if (SelectedLetterWordIndex > -1)
			for index = 0 to SelectedLetterWordIndex
				dec SelectedLettersPlayfieldY[index], 1
				SetSpriteColor( LetterTileSprite[SelectedLettersPlayfieldX[index], SelectedLettersPlayfieldY[index]], 128, 255, 128, 255 )
			next index
		endif
		
		for indexY = 18 to 0 step -1
			for indexX = 0 to 10
				if (Playfield[indexX, indexY] <> "1")
					playfieldHeight = indexY
				endif
			next indexX
		next indexY
	endif
endfunction


//------------------------------------------------------------------------------------------------------------

function KeyboardLetterCheck ( letter as integer )
	letterChar as string
	letterChar = " "

	if     (letter = 65)
		letterChar = "A"
	elseif (letter = 66)
		letterChar = "B"
	elseif (letter = 67)
		letterChar = "C"
	elseif (letter = 68)
		letterChar = "D"
	elseif (letter = 69)
		letterChar = "E"
	elseif (letter = 70)
		letterChar = "F"
	elseif (letter = 71)
		letterChar = "G"
	elseif (letter = 72)
		letterChar = "H"
	elseif (letter = 73)
		letterChar = "I"
	elseif (letter = 74)
		letterChar = "J"
	elseif (letter = 75)
		letterChar = "K"
	elseif (letter = 76)
		letterChar = "L"
	elseif (letter = 77)
		letterChar = "M"
	elseif (letter = 78)
		letterChar = "N"
	elseif (letter = 79)
		letterChar = "O"
	elseif (letter = 80)
		letterChar = "P"
	elseif (letter = 81)
		letterChar = "Q"
	elseif (letter = 82)
		letterChar = "R"
	elseif (letter = 83)
		letterChar = "S"
	elseif (letter = 84)
		letterChar = "T"
	elseif (letter = 85)
		letterChar = "U"
	elseif (letter = 86)
		letterChar = "V"
	elseif (letter = 87)
		letterChar = "W"
	elseif (letter = 88)
		letterChar = "X"
	elseif (letter = 89)
		letterChar = "Y"
	elseif (letter = 90)
		letterChar = "Z"
	endif
			
	indexY as integer
	indexX as integer
	letterFound as integer
	letterFound = -1
	colorRed as integer
	for indexY = 17 to 0 step -1
		for indexX = 0 to 10
			if (Playfield[indexX, indexY] = letterChar and letterFound = -1)				
				colorRed = GetSpriteColorRed(LetterTileSprite[indexX, indexY])
				if (colorRed = 255 and SelectedLetterWordIndex < 9)
					SetSpriteColor( LetterTileSprite[indexX, indexY], 128, 255, 128, 255 ) 
					PlaySoundEffect(2)

					inc SelectedLetterWordIndex, 1

					IconScreenX[3] = (  ( (31/2)+9 ) + (9+1)*31  )
					IconScreenY[3] = 509
					SetSpritePositionByOffset( Icon[80], IconScreenX[3], IconScreenY[3] )
									
					SetText(SelectedLettersTextIndex[SelectedLetterWordIndex+1], Playfield[indexX, indexY])
					SelectedLettersPlayfieldX[SelectedLetterWordIndex] = indexX
					SelectedLettersPlayfieldY[SelectedLetterWordIndex] = indexY
					SelectedLetters[SelectedLetterWordIndex] = Playfield[indexX, indexY]

					letterFound = 1
				endif
					
				PlayfieldIsDirty = TRUE
			endif
		next indexX
	next indexY
endfunction

//------------------------------------------------------------------------------------------------------------

function RunGameplayCore ( )
fallingLetters as integer[3]

	if (ExplosionScale > 0)
		if (ExplosionScale < 4)
			inc ExplosionScale, .5
			if (ExplosionScale > 4) then ExplosionScale = 4
			ScreenIsDirty = TRUE
			SetSpriteScaleByOffset( ExplosionSprite, ExplosionScale, ExplosionScale )
			SetSpriteColorAlpha( ExplosionSprite, (ExplosionAlpha) )
		elseif (ExplosionScale = 4)
			BlowUpSomeOfPlayfield()
			GameStatus = ApplyingGravity
			inc ExplosionScale, .25
		elseif (ExplosionAlpha > 25)
			dec ExplosionAlpha, 25
			if (ExplosionAlpha < 0) then ExplosionAlpha = 0
			inc ExplosionScale, .25
			ScreenIsDirty = TRUE
			SetSpriteScaleByOffset( ExplosionSprite, ExplosionScale, ExplosionScale )
			SetSpriteColorAlpha( ExplosionSprite, (ExplosionAlpha) )
		else
			ExplosionAlpha = 0
			ExplosionScale = 0

			SetText( FallingLettersTextIndex[0], FallingLettersLetter[0] )
		endif
	endif

	movementY as float
	if (roundedFPS > 0)
		movementY = FallingLetterSpeed[GameMode] * ( (30 / roundedFPS) )
	else
		movementY = FallingLetterSpeed[GameMode]
	endif

	if (NextFallingIsBomb = 1) then movementY = movementY / 2
		
	inc FallingLettersScreenY[0], movementY
	if (FallingLettersCount > 1) then inc FallingLettersScreenY[1], movementY
	if (FallingLettersCount > 2) then inc FallingLettersScreenY[2], movementY
	inc FallingLettersScreenYstep[0], movementY
	if (NextFallingIsBomb = 1)
		SetSpritePositionByOffset( BombFallingSprite, (31/2)+9+((FallingLettersPlayfieldX[0])*31), FallingLettersScreenY[0] )
	else
		SetSpritePositionByOffset( FallingLettersTileSprite[0], (31/2)+9+((FallingLettersPlayfieldX[0])*31), FallingLettersScreenY[0] )
		if (FallingLettersCount > 1) then SetSpritePositionByOffset( FallingLettersTileSprite[1], (31/2)+9+((FallingLettersPlayfieldX[1])*31), FallingLettersScreenY[1] )
		if (FallingLettersCount > 2) then SetSpritePositionByOffset( FallingLettersTileSprite[2], (31/2)+9+((FallingLettersPlayfieldX[2])*31), FallingLettersScreenY[2] )
	endif
	
	if (NextFallingIsBomb = 0 or NextFallingIsBomb = 2)
		SetTextY(FallingLettersTextIndex[0], FallingLettersScreenY[0]-18)
		if (FallingLettersCount > 1) then SetTextY(FallingLettersTextIndex[1], FallingLettersScreenY[1]-18)
		if (FallingLettersCount > 2) then SetTextY(FallingLettersTextIndex[2], FallingLettersScreenY[2]-18)
	endif

	if (  FallingLettersScreenYstep[0] > ( 31 )  )
		FallingLettersScreenYstep[0] = 0

		FallingLettersScreenY[0] = ( 31*FallingLettersPlayfieldY[0] )-(31*2)
		if (FallingLettersCount > 1) then FallingLettersScreenY[1] = ( 31*FallingLettersPlayfieldY[1] )-(31*2)
		if (FallingLettersCount > 2) then FallingLettersScreenY[2] = ( 31*FallingLettersPlayfieldY[2] )-(31*2)

		inc FallingLettersPlayfieldY[0], 1
		if (FallingLettersCount > 1) then inc FallingLettersPlayfieldY[1], 1
		if (FallingLettersCount > 2) then inc FallingLettersPlayfieldY[2], 1
				
		if (FallingLettersPlayfieldY[0] = 18 or Playfield[ FallingLettersPlayfieldX[0], FallingLettersPlayfieldY[0] ] <> "1")
			PlaySoundEffect(11)

			if (NextFallingIsBomb = 2)
				NextFallingIsBomb = 1
				SetTextX( FallingLettersTextIndex[0], -9999)
				SetTextY(FallingLettersTextIndex[0], -9999)
				SetSpritePositionByOffset( FallingLettersTileSprite[0], -9999, -9999 )
				BombHitPlayfieldY = FallingLettersPlayfieldY[0]
			elseif (NextFallingIsBomb = 1)
				SetSpritePositionByOffset( BombFallingSprite, -9999, -9999 )
				ExplosionScale = .25
				ExplosionAlpha = 255

				SetSpriteScaleByOffset( ExplosionSprite, ExplosionScale, ExplosionScale )

				SetSpriteColorAlpha( ExplosionSprite, ExplosionAlpha )

				SetSpritePositionByOffset( ExplosionSprite, (31/2)+9+((FallingLettersPlayfieldX[0])*31), FallingLettersScreenY[0] )

				PlaySoundEffect(5)
				NextFallingIsBomb = 0
			elseif (FallingLettersAfterBombMovePlayfieldX > -1)
				FallingLettersAfterBombMovePlayfieldX = -1
			endif
						
			if (FallingLettersPlayfieldY[0] < 4)
				GameOverTimer = 120
				PlaySoundEffect(10)
				exitfunction
			endif

			PlaySoundEffect(11)

			SetupNextLetters()
			CheckForLowLetters()
		endif
	endif

	indexY as integer
	indexX as integer
	screenY as integer
	screenX as integer
	screenY = 0-(31*2)
	screenX = (31/2)+9
	colorRed as integer
	if (NextFallingIsBomb = 0 and ExplosionAlpha = 0)
		if (OnMobile = FALSE)		
			if LastKeyboardChar = -1
				LaskKeyboardKey = -1
			endif

			index as integer
			if DelayAllUserInput = 0	
				for index = 65 to 90
					if (LastKeyboardChar = index and LaskKeyboardKey = -1)
						KeyboardLetterCheck(index)
						LaskKeyboardKey = LastKeyboardChar
						PlaySoundEffect(0)
					endif
				next index
		
				if LastKeyboardChar = 107 and (LaskKeyboardKey <> LastKeyboardChar)
					LaskKeyboardKey = LastKeyboardChar
					PlaySoundEffect(0)
				elseif LastKeyboardChar = 32 and (LaskKeyboardKey <> LastKeyboardChar)
					LaskKeyboardKey = LastKeyboardChar
					PlaySoundEffect(0)
				elseif LastKeyboardChar = 8 and (LaskKeyboardKey <> LastKeyboardChar)
					IconAnimationTimer[3] = 2
					GUIchanged = TRUE
					CurrentIconBeingPressed = index
					LaskKeyboardKey = LastKeyboardChar
					PlaySoundEffect(0)
				elseif LastKeyboardChar = 13 and (LaskKeyboardKey <> LastKeyboardChar)
					CheckSelectedLettersForWord()
					LaskKeyboardKey = LastKeyboardChar
					PlaySoundEffect(0)
				endif
			endif

			for indexY = 0 to 18
				for indexX = 0 to 10
					if (Playfield[indexX, indexY] <> "1")
						if (MouseButtonLeft = ON)
							if (  MouseScreenX > ( screenX-(GetSpriteWidth(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenX < ( screenX+(GetSpriteWidth(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenY > ( screenY-(GetSpriteHeight(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenY < ( screenY+(GetSpriteHeight(LetterTileSprite[indexX, indexY])/2) )  )
								colorRed = GetSpriteColorRed(LetterTileSprite[indexX, indexY])
								if (colorRed = 255 and SelectedLetterWordIndex < 9)
									SetSpriteColor( LetterTileSprite[indexX, indexY], 128, 255, 128, 255 ) 
									PlaySoundEffect(2)

									inc SelectedLetterWordIndex, 1

									IconScreenX[3] = (  ( (31/2)+9 ) + (9+1)*31  )
									IconScreenY[3] = 509
									SetSpritePositionByOffset( Icon[80], IconScreenX[3], IconScreenY[3] )
													
									SetText(SelectedLettersTextIndex[SelectedLetterWordIndex+1], Playfield[indexX, indexY])
									SelectedLettersPlayfieldX[SelectedLetterWordIndex] = indexX
									SelectedLettersPlayfieldY[SelectedLetterWordIndex] = indexY
									SelectedLetters[SelectedLetterWordIndex] = Playfield[indexX, indexY]
								endif
									
								PlayfieldIsDirty = TRUE
							endif
						endif
					endif
					
					inc screenX, 31
				next indexX

				inc screenY, 31
				screenX = (31/2)+9
			next indexY
		elseif (OnMobile = TRUE)
			for indexY = 0 to 18
				for indexX = 0 to 10
					if (Playfield[indexX, indexY] <> "1")
						if (MouseButtonLeftJustClicked = 1 and SelectedLetterWordIndex < 9)
							if (  MouseScreenX > ( screenX-(GetSpriteWidth(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenX < ( screenX+(GetSpriteWidth(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenY > ( screenY-(GetSpriteHeight(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenY < ( screenY+(GetSpriteHeight(LetterTileSprite[indexX, indexY])/2) )  )
								colorRed = GetSpriteColorRed(LetterTileSprite[indexX, indexY])
								if (colorRed = 255 and SelectedLetterWordIndex < 9)
									SetSpriteColor( LetterTileSprite[indexX, indexY], 128, 255, 128, 255 ) 
									PlaySoundEffect(2)

									inc SelectedLetterWordIndex, 1

									IconScreenX[3] = (  ( (31/2)+9 ) + (9+1)*31  )
									IconScreenY[3] = 509
									SetSpritePositionByOffset( Icon[80], IconScreenX[3], IconScreenY[3] )
													
									SetText(SelectedLettersTextIndex[SelectedLetterWordIndex+1], Playfield[indexX, indexY])
									SelectedLettersPlayfieldX[SelectedLetterWordIndex] = indexX
									SelectedLettersPlayfieldY[SelectedLetterWordIndex] = indexY
									SelectedLetters[SelectedLetterWordIndex] = Playfield[indexX, indexY]

									screenX = (31/2)+9
									for indexX = 0 to (SelectedLetterWordIndex)
										SetSpritePositionByOffset( SelectedLettersTileSprite[indexX], screenX, 509 )
										SetSpriteColorAlpha( SelectedLettersTileSprite[indexX], CorrectWordTileAndCharAlpha )
										SetTextColorAlpha( SelectedLettersTextIndex[indexX+1], CorrectWordTileAndCharAlpha )
										inc screenX, 31
									next indexX
								endif
							endif
						elseif (MouseButtonLeft = ON and SelectedLetterWordIndex < 9)
							if (  ( (indexX <> FingerPlayfieldX or indexY <> FingerPlayfieldY) ) and ( GetSpriteColorRed(LetterTileSprite[indexX, indexY]) = 255 )  )
								if (  MouseScreenX > ( screenX-(GetSpriteWidth(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenX < ( screenX+(GetSpriteWidth(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenY > ( screenY-(GetSpriteHeight(LetterTileSprite[indexX, indexY])/2) ) and MouseScreenY < ( screenY+(GetSpriteHeight(LetterTileSprite[indexX, indexY])/2) )  )
									if (FingerPlayfieldX > -1 and FingerPlayfieldY > -1)
										colorRed = GetSpriteColorRed(LetterTileSprite[FingerPlayfieldX, FingerPlayfieldY])
										if (colorRed = 255)
											SetSpritePositionByOffset( NameInputCharSprite, -9999, -9999 )
											if GetTextExists(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY])
												SetTextDepth(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY], 3)
												SetTextPosition(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY], GetTextX(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY]), GetTextY(PlayfieldLetterTextIndex[FingerPlayfieldX, FingerPlayfieldY])+80-18)
											endif
										endif
									endif

									FingerPlayfieldX = indexX
									FingerPlayfieldY = indexY
									SetSpritePositionByOffset( NameInputCharSprite, screenX, screenY-50 )
									if GetTextExists(PlayfieldLetterTextIndex[indexX, indexY])
										SetTextDepth(PlayfieldLetterTextIndex[indexX, indexY], 2)
										SetTextPosition(PlayfieldLetterTextIndex[indexX, indexY], screenX, screenY-80)
									endif
								endif
							endif
						else
							SetSpritePositionByOffset( NameInputCharSprite, -9999, -9999 )
							if GetTextExists(PlayfieldLetterTextIndex[indexX, indexY])
								SetTextDepth(PlayfieldLetterTextIndex[indexX, indexY], 3)
								SetTextPosition(PlayfieldLetterTextIndex[indexX, indexY], screenX, screenY-18)
							endif
						endif
					endif
					
					inc screenX, 31
				next indexX
				
				inc screenY, 31
				screenX = (31/2)+9
			next indexY
		endif
	endif
endfunction
