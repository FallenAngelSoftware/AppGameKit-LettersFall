// "screens.agc"...

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

function SetDelayAllUserInput ( delay as integer )
	DelayAllUserInput = delay
endfunction

//------------------------------------------------------------------------------------------------------------

function LoadSelectedBackground()
offset as integer
	offset = 0

	if (ScreenToDisplay <> TitleScreen and ScreenToDisplay <> PlayingScreen)
		inc offset, 10
	endif

	if (WonGame = TRUE)
		TitleBG = CreateSprite ( 8 )
	elseif (SelectedBackground = 0)
		TitleBG = CreateSprite ( 10+offset )
	elseif (SelectedBackground = 1)
		TitleBG = CreateSprite ( 11+offset )
	elseif (SelectedBackground = 2)
		TitleBG = CreateSprite ( 12+offset )
	elseif (SelectedBackground = 3)
		TitleBG = CreateSprite ( 13+offset )
	endif

	SetSpriteOffset( TitleBG, (GetSpriteWidth(TitleBG)/2) , (GetSpriteHeight(TitleBG)/2) ) 
	SetSpritePositionByOffset( TitleBG, -9999, -9999 )
	SetSpriteDepth ( TitleBG, 5 )

endfunction

//------------------------------------------------------------------------------------------------------------

function ApplyScreenFadeTransition ( )
	if ScreenFadeStatus = FadingFromBlack
		if ScreenFadeTransparency > 85
			dec ScreenFadeTransparency, 85
		else
			ScreenFadeTransparency = 0
			ScreenFadeStatus = FadingIdle
		endif
		
		SetSpriteColorAlpha( FadingBlackBG, ScreenFadeTransparency )
	elseif ScreenFadeStatus = FadingToBlack
		if ScreenFadeTransparency < 255-85
			inc ScreenFadeTransparency, 85
			
			if (ScreenFadeTransparency = 255-85) then ScreenFadeTransparency = 254
		elseif ScreenFadeTransparency = 254
			ScreenFadeTransparency = 255
		elseif (ScreenFadeTransparency = 255)
			ScreenFadeTransparency = 255

			ScreenFadeStatus = FadingFromBlack
			ScreenToDisplay = NextScreenToDisplay

			DestroyAllGUI()
			
			DestroyAllTexts()
			
			DeleteAllSprites()
			
			FadingBlackBG = CreateSprite ( 1 )
			SetSpriteDepth ( FadingBlackBG, 1 )
			SetSpriteOffset( FadingBlackBG, (GetSpriteWidth(FadingBlackBG)/2) , (GetSpriteHeight(FadingBlackBG)/2) ) 
			SetSpritePositionByOffset( FadingBlackBG, ScreenWidth/2, ScreenHeight/2 )
			SetSpriteTransparency( FadingBlackBG, 1 )

			LoadSelectedBackground()

			LoadInterfaceSprites()
			
			if (ScreenToDisplay <> PlayingScreen) then PreRenderButtonsWithTexts()
		endif
		
		SetSpriteColorAlpha( FadingBlackBG, ScreenFadeTransparency )
	endif
	
	if (SecretCodeCombined = 2777 and ScreenIsDirty = TRUE and ScreenFadeStatus = FadingIdle)
		SetSpriteColorAlpha( FadingBlackBG, 200 )
	endif

endfunction

//------------------------------------------------------------------------------------------------------------

function DisplaySteamOverlayScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255

		ClearScreenWithColor ( 0, 0, 0 )

		BlackBG = CreateSprite ( 3 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "TM", 999, 8, 255, 255, 255, 255, 90, 90, 90, 0, 180+92, 23-14, 3 )
		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "''LettersFall 110%''", 999, 30, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, 29, 3 )
		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "Copyright 2022 By Fallen Angel Software", 999, 18, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, 29+25, 3 )
		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "www.FallenAngelSoftware.com", 999, 18, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, 29+25+25, 3 )

		ClickToContinueText = CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "Please Wait!", 999, 30, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, ScreenHeight*.5, 3 )

		ScreenDisplayTimer = 50
		NextScreenToDisplay = AppGameKitScreen

		ScreenIsDirty = TRUE
	endif

	if ScreenDisplayTimer > 0
		LoadPercent = 275 / ScreenDisplayTimer
		LoadPercentFixed = LoadPercent
		if (LoadPercentFixed > 100) then LoadPercentFixed = 100
		SetText( LoadPercentText, str(LoadPercentFixed)+"%" )

		dec ScreenDisplayTimer, 1
		if (ScreenDisplayTimer = 0) then SetTextStringOutlined ( ClickToContinueText, "CLICK Screen To Continue!" )
	elseif ScreenDisplayTimer = 0
		if (MouseButtonLeft = ON)
			PlaySoundEffect(1)
			ScreenFadeStatus = FadingToBlack
			ScreenDisplayTimer = -1
			SetDelayAllUserInput(50)
		endif
		SetText( LoadPercentText, "100%" )
	endif

	ScreenIsDirty = TRUE

	if (OnMobile = TRUE and ScreenFadeStatus = FadingIdle)
		ScreenFadeStatus = FadingToBlack
		NextScreenToDisplay = 3
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
		if (OnMobile = FALSE) then PlayNewMusic(0, 1)
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayAppGameKitScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )
		
		BlackBG = CreateSprite ( 1 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )

		AppGameKitLogo = CreateSprite ( 5 )
		SetSpriteDepth ( AppGameKitLogo, 3 )
		SetSpriteOffset( AppGameKitLogo, (GetSpriteWidth(AppGameKitLogo)/2) , (GetSpriteHeight(AppGameKitLogo)/2) ) 
		SetSpritePositionByOffset( AppGameKitLogo, ScreenWidth/2, (ScreenHeight/2) )
		
		ScreenDisplayTimer = 200
		NextScreenToDisplay = SixteenBitSoftScreen

		ScreenIsDirty = TRUE
	endif

	if ScreenDisplayTimer > 0
		dec ScreenDisplayTimer, 1
	elseif ScreenDisplayTimer = 0
		ScreenFadeStatus = FadingToBlack
	endif
	
	if ScreenDisplayTimer > 0
		if MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27
			PlaySoundEffect(1)
			SetDelayAllUserInput(14)
			ScreenDisplayTimer = 0
		endif
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplaySixteenBitSoftScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )
		
		BlackBG = CreateSprite ( 2 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Fallen Angel Software", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, 22, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Presents:", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, 22+30+110, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "A", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, (ScreenHeight/2)-15-35, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''JeZxLee''", 999, 50, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, (ScreenHeight/2)-15, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Game", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, (ScreenHeight/2)-15+35, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "www.FallenAngelSoftware.com", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, ScreenHeight-22, 3)
		
		ScreenDisplayTimer = 200
		NextScreenToDisplay = TitleScreen

		ScreenIsDirty = TRUE

		DictionaryLetterLoading = 0
	endif

	if (DictionaryLetterLoading < 26)
		LoadDictionaryLetterFile()
		inc DictionaryLetterLoading, 1
	else
		if ScreenDisplayTimer > 0
			dec ScreenDisplayTimer, 1
		elseif ScreenDisplayTimer = 0
			ScreenFadeStatus = FadingToBlack
		endif
		
		if ScreenDisplayTimer > 0
			if MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27
				PlaySoundEffect(1)
				SetDelayAllUserInput(14)
				ScreenDisplayTimer = 0
			endif
		endif
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayTitleScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		SaveOptionsAndHighScores()
		
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		if MusicVolume > 0 or EffectsVolume > 0
			CreateIcon(1, 18, 18 )
		else
			CreateIcon(0, 18, 18 )
		endif

		offsetY as integer
		offsetY = 10

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, GameVersion, 999, 16, 0, 188, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 17-4, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, GameVersion, 999, 16, 0, 128, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 17+4, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, GameVersion, 999, 16, 0, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 17, 3)

		LF110Logo = CreateSprite ( 35 )
		SetSpriteOffset( LF110Logo, (GetSpriteWidth(LF110Logo)/2) , (GetSpriteHeight(LF110Logo)/2) ) 
		SetSpritePositionByOffset( LF110Logo, ScreenWidth/2, 49+offsetY+33+5+15 )
		SetSpriteDepth ( LF110Logo, 3 )
			
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "™", 999, 25, 90, 251, 255, 255, 0, 0, 0, 1, ScreenWidth-12, 40-19+18, 3)
				
		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 105+offsetY+13+5+28+15+15 )
		SetSpriteColor(ScreenLine[0], 90, 251, 255, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''"+HighScoreName [ GameMode, 0 ]+"''", 999, 19, 90, 251, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 125+offsetY+13+5+28+12+15, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreScore [ GameMode, 0 ]), 999, 19, 90, 251, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 125+21+offsetY+13+5+28+12+15, 3)

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 165+offsetY+13+3+28+10+15 )
		SetSpriteColor(ScreenLine[1], 90, 251, 255, 255)

		startScreenY as integer = 263
		inc startScreenY, offsetY
		offsetScreenY as integer = 43
		if (OnMobile = TRUE) then offsetScreenY = 48
		CreateButton( 0, (ScreenWidth / 2), startScreenY + (offsetScreenY*0) )
		CreateButton( 1, (ScreenWidth / 2), startScreenY + (offsetScreenY*1) )
		CreateButton( 2, (ScreenWidth / 2), startScreenY + (offsetScreenY*2) )
		CreateButton( 3, (ScreenWidth / 2), startScreenY + (offsetScreenY*3) )
		CreateButton( 4, (ScreenWidth / 2), startScreenY + (offsetScreenY*4) )
		if (OnMobile = FALSE)
			CreateButton( 5, (ScreenWidth / 2), startScreenY + (offsetScreenY*5) )
		endif

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, ScreenHeight-165+offsetY+13+19 )
		SetSpriteColor(ScreenLine[2], 90, 251, 255, 255)

		SetSpritePositionByOffset( ScreenLine[3], ScreenWidth/2, ScreenHeight-40+offsetY-15+13 )
		SetSpriteColor(ScreenLine[3], 90, 251, 255, 255)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "©2022 By", 999, 26, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, ScreenHeight-25+13-2-40-50-5-3+7, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Team", 999, 26, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, ScreenHeight-25+13-2-20-50-1+7, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''www.FallenAngelSoftware.com''", 999, 26, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, ScreenHeight-25+13-2-50+5+7, 3)

		if (SecretCodeCombined = 5432 or SecretCodeCombined = 5431) then CreateIcon(6, 360-17, 17)
		
		GameIsPlaying = FALSE

		ScreenIsDirty = TRUE
	endif

	if (DictionaryLetterLoading < 26)
		LoadDictionaryLetterFile()
		inc DictionaryLetterLoading, 1
	else
		if ThisIconWasPressed(0) = TRUE
			if MusicVolume > 0 or EffectsVolume > 0
				SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
				IconSprite[0] = 0
				SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
				MusicVolume = 0
				EffectsVolume = 0
				SetVolumeOfAllMusicAndSoundEffects()
				GUIchanged = TRUE
			else
				SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
				IconSprite[0] = 1
				SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
				MusicVolume = 100
				EffectsVolume = 100
				SetVolumeOfAllMusicAndSoundEffects()
				GUIchanged = TRUE
			endif
			SaveOptionsAndHighScores()
		elseif ThisIconWasPressed(1) = TRUE
			MusicVolume = 100
			EffectsVolume = 100
			SetVolumeOfAllMusicAndSoundEffects()
			GUIchanged = TRUE
			
			MusicPlayerScreenIndex = 0

			NextScreenToDisplay = MusicPlayerScreen
			ScreenFadeStatus = FadingToBlack
		endif

		if ThisButtonWasPressed(0) = TRUE
			if (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
				NextScreenToDisplay = IntroSceneScreen
			else
				NextScreenToDisplay = PlayingScreen
			endif
			
			DelayAllUserInput = 30
			ScreenFadeStatus = FadingToBlack
		elseif ThisButtonWasPressed(1) = TRUE
			NextScreenToDisplay = OptionsScreen
			ScreenFadeStatus = FadingToBlack
		elseif ThisButtonWasPressed(2) = TRUE
			NextScreenToDisplay = HowToPlayScreen
			ScreenFadeStatus = FadingToBlack
		elseif ThisButtonWasPressed(3) = TRUE
			NextScreenToDisplay = HighScoresScreen
			ScreenFadeStatus = FadingToBlack
		elseif ThisButtonWasPressed(4) = TRUE
			NextScreenToDisplay = AboutScreen
			ScreenFadeStatus = FadingToBlack
		elseif ThisButtonWasPressed(5) = TRUE
			if (OnMobile = FALSE)
				SetDelayAllUserInput(5)
				NextScreenToDisplay = ExitScreen
				ScreenFadeStatus = FadingToBlack
			endif
		endif
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayOptionsScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''O P T I O N S''", 999, 30, 90, 251, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 90, 251, 255, 255)

		CreateArrowSet(75-17)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Music Volume:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 75-17, 3)
		ArrowSetTextStringIndex[0] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 75-17, 3)
		if MusicVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "100%" )
		elseif MusicVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "75%" )
		elseif MusicVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "50%" )
		elseif MusicVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "25%" )
		elseif MusicVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "0%" )
		endif

		CreateArrowSet(75+44-17)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Effects Volume:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 75+44-17, 3)
		ArrowSetTextStringIndex[1] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 75+44-17, 3)
		if EffectsVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "100%" )
		elseif EffectsVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "75%" )
		elseif EffectsVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "50%" )
		elseif EffectsVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "25%" )
		elseif EffectsVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "0%" )
		endif

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 150-17 )
		SetSpriteColor(ScreenLine[1], 90, 251, 255, 255)

		CreateArrowSet(180-19)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Game Mode:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 180-19, 3)
		ArrowSetTextStringIndex[2] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 180-19, 3)
		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Child" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Teen" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Adult" )
		elseif GameMode = ChildNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Child" )
		elseif GameMode = TeenNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Teen" )
		elseif GameMode = AdultNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Adult" )
		endif

		CreateArrowSet(180+44+23-38-3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Background:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 180+44+23-38-3, 3)
		ArrowSetTextStringIndex[3] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 180+44+23-38-3, 3)
		if SelectedBackground = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[3], "Waterfall" )
		elseif SelectedBackground = 1
			SetTextStringOutlined ( ArrowSetTextStringIndex[3], "Kitten" )
		elseif SelectedBackground = 2
			SetTextStringOutlined ( ArrowSetTextStringIndex[3], "Sunflowers" )
		elseif SelectedBackground = 3
			SetTextStringOutlined ( ArrowSetTextStringIndex[3], "Beach" )
		endif

		CreateArrowSet(180+44+23-38+38+2)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Starting Level:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 180+44+23-38+38+2, 3)
		ArrowSetTextStringIndex[4] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 180+44+23-38+38+2, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, 256+16+5 )
		SetSpriteColor(ScreenLine[2], 90, 251, 255, 255)

		CreateArrowSet(288+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #1:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+16, 3)
		ArrowSetTextStringIndex[5] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[5], str(SecretCode[0]) )

		CreateArrowSet(288+44+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #2:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+44+16, 3)
		ArrowSetTextStringIndex[6] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+44+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[6], str(SecretCode[1]) )

		CreateArrowSet(288+44+44+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #3:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+44+44+16, 3)
		ArrowSetTextStringIndex[7] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+44+44+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[7], str(SecretCode[2]) )

		CreateArrowSet(288+44+44+44+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #4:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+44+44+44+16, 3)
		ArrowSetTextStringIndex[8] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+44+44+44+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[8], str(SecretCode[3]) )

		SetSpritePositionByOffset( ScreenLine[3], ScreenWidth/2, 443+19 )
		SetSpriteColor(ScreenLine[3], 90, 251, 255, 255)
		
		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 90, 251, 255, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )


		if ShowCursor = TRUE
			CreateIcon(2, (ScreenWidth/2), (ScreenHeight-100+13)-25 )
		elseif ShowCursor = FALSE
			CreateIcon(3, (ScreenWidth/2), (ScreenHeight-100+13)-25 )
		endif

		ChangingBackground = FALSE
		ScreenIsDirty = TRUE
	endif

	if ThisButtonWasPressed(6) = TRUE
		SetDelayAllUserInput(14)
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	endif

	if ThisIconWasPressed(0) = TRUE
		OpenBrowser( "https://play.google.com/store/apps/details?id=com.fallenangelsoftware.lettersfall" )
	endif

	if ThisArrowWasPressed(0) = TRUE
		if MusicVolume > 0
			dec MusicVolume, 25
		else
			MusicVolume = 100
		endif

		if MusicVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "100%" )
		elseif MusicVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "75%" )
		elseif MusicVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "50%" )
		elseif MusicVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "25%" )
		elseif MusicVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(.5) = TRUE
		if MusicVolume < 100
			inc MusicVolume, 25
		else
			MusicVolume = 0
		endif

		if MusicVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "100%" )
		elseif MusicVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "75%" )
		elseif MusicVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "50%" )
		elseif MusicVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "25%" )
		elseif MusicVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(1) = TRUE
		if EffectsVolume > 0
			dec EffectsVolume, 25
		else
			EffectsVolume = 100
		endif

		if EffectsVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "100%" )
		elseif EffectsVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "75%" )
		elseif EffectsVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "50%" )
		elseif EffectsVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "25%" )
		elseif EffectsVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(1.5) = TRUE
		if EffectsVolume < 100
			inc EffectsVolume, 25
		else
			EffectsVolume = 0
		endif

		if EffectsVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "100%" )
		elseif EffectsVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "75%" )
		elseif EffectsVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "50%" )
		elseif EffectsVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "25%" )
		elseif EffectsVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(2) = TRUE
		if GameMode > 0
			dec GameMode, 1
		else
			GameMode = 5
		endif

		if (StartingLevel > LevelSkip[GameMode]) then StartingLevel = 0
		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Child" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Teen" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Adult" )
		elseif GameMode = ChildNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Child" )
		elseif GameMode = TeenNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Teen" )
		elseif GameMode = AdultNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Adult" )
		endif

		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(2.5) = TRUE
		if GameMode < 5
			inc GameMode, 1
		else
			GameMode = 0
		endif

		if (StartingLevel > LevelSkip[GameMode]) then StartingLevel = 0
		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Child" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Teen" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Story Adult" )
		elseif GameMode = ChildNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Child" )
		elseif GameMode = TeenNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Teen" )
		elseif GameMode = AdultNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "No End Adult" )
		endif

		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(3) = TRUE
		if SelectedBackground > 0
			dec SelectedBackground, 1
		else
			SelectedBackground = 3
		endif

		ChangingBackground = TRUE
		ScreenFadeStatus = FadingToBlack
		NextScreenToDisplay = OptionsScreen
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(3.5) = TRUE
		if SelectedBackground < 3
			inc SelectedBackground, 1
		else
			SelectedBackground = 0
		endif

		ChangingBackground = TRUE
		ScreenFadeStatus = FadingToBlack
		NextScreenToDisplay = OptionsScreen
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(4) = TRUE
		if (StartingLevel > 0)
			dec StartingLevel, 1
		else
			StartingLevel = LevelSkip[GameMode]
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(4.5) = TRUE
		if (StartingLevel < LevelSkip[GameMode])
			inc StartingLevel, 1
		else
			StartingLevel = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(5) = TRUE
		if SecretCode[0] > 0
			dec SecretCode[0], 1
		else
			SecretCode[0] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[5], str(SecretCode[0]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(5.5) = TRUE
		if SecretCode[0] < 9
			inc SecretCode[0], 1
		else
			SecretCode[0] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[5], str(SecretCode[0]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(6) = TRUE
		if SecretCode[1] > 0
			dec SecretCode[1], 1
		else
			SecretCode[1] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[6], str(SecretCode[1]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(6.5) = TRUE
		if SecretCode[1] < 9
			inc SecretCode[1], 1
		else
			SecretCode[1] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[6], str(SecretCode[1]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(7) = TRUE
		if SecretCode[2] > 0
			dec SecretCode[2], 1
		else
			SecretCode[2] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[7], str(SecretCode[2]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(7.5) = TRUE
		if SecretCode[2] < 9
			inc SecretCode[2], 1
		else
			SecretCode[2] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[7], str(SecretCode[2]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(8) = TRUE
		if SecretCode[3] > 0
			dec SecretCode[3], 1
		else
			SecretCode[3] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[8], str(SecretCode[3]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	elseif ThisArrowWasPressed(8.5) = TRUE
		if SecretCode[3] < 9
			inc SecretCode[3], 1
		else
			SecretCode[3] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[8], str(SecretCode[3]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput(14)
	endif

	if (SecretCodeCombined = 2777)
		SetSpritePositionByOffset( FadingBlackBG,  -80, -200 )
		SetSpriteColorAlpha( FadingBlackBG, 200 )
	else
		SetSpritePositionByOffset( FadingBlackBG,  ScreenWidth/2, ScreenHeight/2 )
		SetSpriteColorAlpha( FadingBlackBG, 0 )
	endif

	DrawAllArrowSets()
	
	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction
	
//------------------------------------------------------------------------------------------------------------

function DisplayHowToPlayScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''H O W   T O   P L A Y''", 999, 30, 90, 251, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 90, 251, 255, 255)
		
		textScreenY as integer
		textScreenY = 55

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Letters will fall from top into playfield.", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, textScreenY, 3)
	
		inc textScreenY, 30
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Select letters to spell", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 5, textScreenY, 3)

		indexX as integer
		for indexX = 0 to 4
			HowToPlayWordsTileSprite[indexX] = CreateSprite ( 41 )
			SetSpriteOffset( HowToPlayWordsTileSprite[indexX], (GetSpriteWidth(HowToPlayWordsTileSprite[indexX])/2) , (GetSpriteHeight(HowToPlayWordsTileSprite[indexX])/2) ) 
			SetSpritePositionByOffset( HowToPlayWordsTileSprite[indexX], -9999, -9999 )
			SetSpriteDepth ( HowToPlayWordsTileSprite[indexX], 4 )
		next indexX

		tileScreenY as integer
		tileScreenY = textScreenY-1
		tileScreenX as integer
		tileScreenX = 205
		offsetX as integer
		offsetX = 31
		SetSpritePositionByOffset( HowToPlayWordsTileSprite[0], tileScreenX, tileScreenY )
		CreateAndInitializeOutlinedText(FALSE, CurrentMinTextIndex, "W", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, tileScreenX, tileScreenY, 3)
		inc tileScreenX, offsetX
		SetSpritePositionByOffset( HowToPlayWordsTileSprite[1], tileScreenX, tileScreenY )
		CreateAndInitializeOutlinedText(FALSE, CurrentMinTextIndex, "O", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, tileScreenX, tileScreenY, 3)
		inc tileScreenX, offsetX
		SetSpritePositionByOffset( HowToPlayWordsTileSprite[2], tileScreenX, tileScreenY )
		CreateAndInitializeOutlinedText(FALSE, CurrentMinTextIndex, "R", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, tileScreenX, tileScreenY, 3)
		inc tileScreenX, offsetX
		SetSpritePositionByOffset( HowToPlayWordsTileSprite[3], tileScreenX, tileScreenY )
		CreateAndInitializeOutlinedText(FALSE, CurrentMinTextIndex, "D", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, tileScreenX, tileScreenY, 3)
		inc tileScreenX, offsetX
		SetSpritePositionByOffset( HowToPlayWordsTileSprite[4], tileScreenX, tileScreenY )
		CreateAndInitializeOutlinedText(FALSE, CurrentMinTextIndex, "S", 999, 30, 0, 0, 0, 255, 232, 166, 0, 1, tileScreenX, tileScreenY, 3)
		inc tileScreenX, offsetX
	
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, ".", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, ScreenWidth-5, textScreenY, 3)

		inc textScreenY, 30
		
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Spell fast enough or the game will end!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, textScreenY, 3)

		inc textScreenY, 30
		
		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, textScreenY-10 )
		SetSpriteColor(ScreenLine[1], 90, 251, 255, 255)
												
		HowToPlayBG = CreateSprite ( 48 )
		SetSpriteOffset( HowToPlayBG, (GetSpriteWidth(HowToPlayBG)/2) , (GetSpriteHeight(HowToPlayBG)/2) ) 
		SetSpritePositionByOffset( HowToPlayBG, (ScreenWidth/2), (ScreenHeight/2)+40 )
		SetSpriteDepth ( HowToPlayBG, 4 )

		ArrowIconSprite = CreateSprite ( 49 )
		SetSpriteOffset( ArrowIconSprite, (GetSpriteWidth(ArrowIconSprite)/2) , (GetSpriteHeight(ArrowIconSprite)/2) ) 
		SetSpritePositionByOffset( ArrowIconSprite, 89, 449 )
		SetSpriteDepth ( ArrowIconSprite, 4 )

		ArrowIconAnimationStep = 0
		ArrowIconAnimationDelay = 0

		HowToPlayLetters = CreateSprite ( 26 )
		SetSpriteOffset( HowToPlayLetters, (GetSpriteWidth(HowToPlayLetters)/2) , (GetSpriteHeight(HowToPlayLetters)/2) ) 
		SetSpritePositionByOffset( HowToPlayLetters, 148, 484 )
		SetSpriteDepth ( HowToPlayLetters, 4 )
		
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20, 484+20 ) 

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 90, 251, 255, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )

		ScreenIsDirty = TRUE
	endif

	if (ArrowIconAnimationStep = 0)
		SetSpritePositionByOffset( ArrowIconSprite, 94, 454 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20, 484+20 ) 
	elseif (ArrowIconAnimationStep = 1)
		SetSpritePositionByOffset( ArrowIconSprite, 113, 373 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20+20, 484+20 ) 
	elseif (ArrowIconAnimationStep = 2)
		SetSpritePositionByOffset( ArrowIconSprite, 153, 473 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20+20+20, 484+20 ) 
	elseif (ArrowIconAnimationStep = 3)
		SetSpritePositionByOffset( ArrowIconSprite, 174, 413 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20+20+20+22, 484+20 ) 
	elseif (ArrowIconAnimationStep = 4)
		SetSpritePositionByOffset( ArrowIconSprite, 213, 391 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20+20+20+22+20, 484+20 ) 
	elseif (ArrowIconAnimationStep = 5)
		SetSpritePositionByOffset( ArrowIconSprite, 233, 432 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20+20+20+22+20+20, 484+20 ) 
	elseif (ArrowIconAnimationStep = 6)
		SetSpritePositionByOffset( ArrowIconSprite, 254, 451 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20+20+20+22+20+20+20, 484+20 ) 
	elseif (ArrowIconAnimationStep = 7)
		SetSpritePositionByOffset( ArrowIconSprite, 294, 390 )
		SetSpriteScissor( HowToPlayLetters, 67, 484-20, 67+20+20+20+22+20+20+20+20+2, 484+20 ) 
	elseif (ArrowIconAnimationStep = 8)
		SetSpritePositionByOffset( ArrowIconSprite, 196, 527 )
	endif

	if (ArrowIconAnimationDelay < 20)
		inc ArrowIconAnimationDelay, 1
	else
		inc ArrowIconAnimationStep, 1
		ArrowIconAnimationDelay = 0
		ScreenIsDirty = TRUE
	endif

	if (ArrowIconAnimationStep > 8) then ArrowIconAnimationStep = 0

	if ThisButtonWasPressed(6) = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayHighScoresScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''H I G H   S C O R E S''", 999, 30, 90, 251, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 90, 251, 255, 255)

		CreateArrowSet(75)
		ArrowSetTextStringIndex[0] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), 75, 3)
		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "Story Child" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "Story Teen" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "Story Adult" )
		elseif GameMode = ChildNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "No End Child" )
		elseif GameMode = TeenNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "No End Teen" )
		elseif GameMode = AdultNeverEndMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "No End Adult" )
		endif

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "NAME", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 29, 130, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "LEVEL", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 29+170, 130, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "SCORE", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 29+170+60, 130, 3)
		screenY as integer
		screenY = 150
		rank as integer
		blue as integer
		for rank = 0 to 9
			blue = 255
			if Score = HighScoreScore [ GameMode, rank ] and Level = HighScoreLevel [ GameMode, rank ] then blue = 0
			
			CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(rank+1)+".", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 8, screenY, 3)
			CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, HighScoreName [ GameMode, rank ], 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29, screenY, 3)
			
			if HighScoreLevel[GameMode, rank] < 10
				CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreLevel [ GameMode, rank ]), 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170, screenY, 3)
			elseif (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
				CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "WON!", 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170, screenY, 3)
			else
				CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreLevel [ GameMode, rank ]), 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170, screenY, 3)
			endif
			
			CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreScore [ GameMode, rank ]), 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170+60, screenY, 3)
	
			inc screenY, 40
		next rank

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 90, 251, 255, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )
		
		if SecretCode[0] = 2 and SecretCode[1] = 7 and SecretCode[2] = 7 and SecretCode[3] = 7 then CreateButton( 7, (ScreenWidth/2), (ScreenHeight-85) )

		ScreenIsDirty = TRUE
	endif

	if ThisButtonWasPressed(6) = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisButtonWasPressed(7) = TRUE
		ClearHighScores()
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	if ThisArrowWasPressed(0) = TRUE
		if GameMode > 0
			dec GameMode, 1
		else
			GameMode = 5
		endif
		
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisArrowWasPressed(.5) = TRUE
		if GameMode < 5
			inc GameMode, 1
		else
			GameMode = 0
		endif
		
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	DrawAllArrowSets()
	
	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function SetupAboutScreenTexts( )
	outline as integer
	outline = TRUE

	startScreenY as integer
	startScreenY = 640+15
	AboutTextsScreenY[0] = startScreenY
	StartIndexOfAboutScreenTexts = CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[0], 999, 16, 255, 255, AboutTextsBlue[0], 255, 0, 0, 0, 1, ScreenWidth/2+110, AboutTextsScreenY[0], 3)
	inc startScreenY, 25
	AboutTextsScreenY[1] = startScreenY
	CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[1], 999, 32, 255, 255, AboutTextsBlue[1], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[1], 3)

	index as integer
	for index = 2 to (NumberOfAboutScreenTexts-1)
		if AboutTextsBlue[index-1] = 0
			inc startScreenY, 30
		elseif AboutTextsBlue[index-1] = 254
			inc startScreenY, 30
		elseif AboutTextsBlue[index] = 254
			inc startScreenY, 30
		elseif AboutTextsBlue[index-1] = 255 and AboutTextsBlue[index] = 255
			inc startScreenY, 30
		else
			inc startScreenY, 80
		endif

		if index = (NumberOfAboutScreenTexts-2)
			inc startScreenY, 320-45
		endif

		AboutTextsScreenY[index] = startScreenY
		
		if (AboutTexts[index] = "Hyper-Custom ''JeZxLee'' Pro-Built Desktop")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 15, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		elseif (AboutTexts[index] = "GIGABYTE® GA-970A-DS3P 2.0 AM3+ Motherboard")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 13, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		elseif (AboutTexts[index] = "nVidia® GeForce GTX 970TT 4GB GDDR5 GPU")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 15, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		elseif (AboutTexts[index] = "Western Digital® 1TB HDD Hard Drive(Personal Data)")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 13, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		else
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 17, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		endif
	next index
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayAboutScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		SetDelayAllUserInput(14)

		ClearScreenWithColor ( 0, 0, 0 )

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		if (WonGame = TRUE)
			Kiss = CreateSprite ( 9 )
			SetSpriteDepth ( Kiss, 3 )
			SetSpriteOffset( Kiss, (GetSpriteWidth(Kiss)/2) , (GetSpriteHeight(Kiss)/2) ) 
			SetSpritePositionByOffset( Kiss, ScreenWidth/2, (ScreenHeight/2)+15 )
			
			if (GameMode = ChildStoryMode)
				PlayNewMusic(11, 1)
			elseif (GameMode = TeenStoryMode)
				PlayNewMusic(12, 1)
			elseif (GameMode = AdultStoryMode)
				PlayNewMusic(13, 1)
			endif
		endif

		NextScreenToDisplay = TitleScreen

		SetupAboutScreenTexts()

		AboutScreenTextFrameSkip = 0
		
		AboutScreenOffsetY = 0
		AboutScreenBackgroundY = 320

		AboutScreenFPSY = -200

		ScreenIsDirty = TRUE

		multiplier = 1.5
	endif

	if JoystickDirection = JoyUP
		multiplier = 10
	else
		multiplier = 1.5

		if (PerformancePercent > 1)
			multiplier = 1.5 * PerformancePercent
		endif
	endif

	if AboutScreenOffsetY > (AboutTextsScreenY[NumberOfAboutScreenTexts-1]+10) or MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27
		ScreenFadeStatus = FadingToBlack
		if AboutScreenOffsetY < (AboutTextsScreenY[NumberOfAboutScreenTexts-1]+10) then PlaySoundEffect(1)
		SetDelayAllUserInput(14)
	endif

	if (ScreenFadeStatus = FadingIdle)
		inc AboutScreenOffsetY, multiplier
		inc AboutScreenBackgroundY, multiplier
		inc AboutScreenFPSY, multiplier
		
		if (WonGame = TRUE) then SetSpritePositionByOffset( Kiss, ScreenWidth/2, 15+AboutScreenBackgroundY )
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, AboutScreenBackgroundY )

		if (SecretCodeCombined = 2777) then SetSpritePositionByOffset( FadingBlackBG, -80, AboutScreenFPSY )

		SetViewOffset( 0, AboutScreenOffsetY )
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
		SetViewOffset( 0, 0 )
		if (WonGame = TRUE)
			if (PlayerRankOnGameOver < 10)
				if (OnMobile = TRUE)
					NextScreenToDisplay = NewHighScoreNameInputAndroidScreen
				else
					NextScreenToDisplay = NewHighScoreNameInputScreen
				endif
			else	
				NextScreenToDisplay = HighScoresScreen
			endif
		elseif (WonGame = FALSE)
			NextScreenToDisplay = TitleScreen
		endif
		
		WonGame = FALSE
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayMusicPlayerScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''M U S I C   S C R E E N''", 999, 30, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "CHOOSE", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 120, 3)

		PlayNewMusic(MusicPlayerScreenIndex, 1)

		CreateArrowSet(ScreenHeight/3)
		ArrowSetTextStringIndex[0] = CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), (ScreenHeight/3), 3 )
		if MusicPlayerScreenIndex = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Title" )
		elseif MusicPlayerScreenIndex = 1
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Story 0-1" )
		elseif MusicPlayerScreenIndex = 2
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Story 2-3" )
		elseif MusicPlayerScreenIndex = 3
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Story 4-5" )
		elseif MusicPlayerScreenIndex = 4
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Story 6-7" )
		elseif MusicPlayerScreenIndex = 5
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Story 8-9" )
		elseif MusicPlayerScreenIndex = 6
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Never End" )
		elseif MusicPlayerScreenIndex = 7
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: High Score" )
		elseif MusicPlayerScreenIndex = 8
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Cut Scene 1" )
		elseif MusicPlayerScreenIndex = 9
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Cut Scene 2" )
		elseif MusicPlayerScreenIndex = 10
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Cut Scene 3(Not Used)" )
		elseif MusicPlayerScreenIndex = 11
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Win Child" )
		elseif MusicPlayerScreenIndex = 12
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Win Teen" )
		elseif MusicPlayerScreenIndex = 13
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Win Adult" )
		endif

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "YOUR", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "BGM", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300+75, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "MUSIC!", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300+75+75, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "(Not Final!)", 999, 35, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300+75+75+80, 3)

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )

		ScreenIsDirty = TRUE
	endif

	if ThisButtonWasPressed(6) = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
		MusicPlayerScreenIndex = 0
		PlayNewMusic(0, 1)
	endif

	if ThisArrowWasPressed(0) = TRUE
		if MusicPlayerScreenIndex > 0
			dec MusicPlayerScreenIndex, 1
		else
			if (SecretCodeCombined <> 5431)
				MusicPlayerScreenIndex = 10
			else
				MusicPlayerScreenIndex = 13
			endif
		endif
		
		NextScreenToDisplay = MusicPlayerScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisArrowWasPressed(.5) = TRUE
		if MusicPlayerScreenIndex < 13
			inc MusicPlayerScreenIndex, 1
		else
			MusicPlayerScreenIndex = 0
		endif

		if (SecretCodeCombined <> 5431 and MusicPlayerScreenIndex > 10) then MusicPlayerScreenIndex = 0
		
		NextScreenToDisplay = MusicPlayerScreen
		ScreenFadeStatus = FadingToBlack
	endif

	DrawAllArrowSets()
	
	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayPlayingScreen( )
indexY as integer
indexX as integer	
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )
		
		PlayfieldSprite = CreateSprite ( 40 )
		SetSpriteOffset( PlayfieldSprite, (GetSpriteWidth(PlayfieldSprite)/2) , (GetSpriteHeight(PlayfieldSprite)/2) ) 
		SetSpritePositionByOffset( PlayfieldSprite, (ScreenWidth/2), (ScreenHeight-393) )
		SetSpriteColorAlpha( PlayfieldSprite, (255) ) rem 148) )
		SetSpriteDepth ( PlayfieldSprite, 4 )

		GamePausedBG = CreateSprite ( 42 )
		SetSpriteOffset( GamePausedBG, (GetSpriteWidth(GamePausedBG)/2) , (GetSpriteHeight(GamePausedBG)/2) ) 
		SetSpritePositionByOffset( GamePausedBG, -9999, -9999 )
		SetSpriteDepth ( GamePausedBG, 2 )

		for indexY = 0 to 18
			for indexX = 0 to 10
				LetterTileSprite[indexX, indexY] = CreateSprite ( 41 )
				SetSpriteOffset( LetterTileSprite[indexX, indexY], (GetSpriteWidth(LetterTileSprite[indexX, indexY])/2) , (GetSpriteHeight(LetterTileSprite[indexX, indexY])/2) ) 
				SetSpritePositionByOffset( LetterTileSprite[indexX, indexY], -9999, -9999 )
				SetSpriteColorAlpha( LetterTileSprite[indexX, indexY], 255 )
				SetSpriteDepth ( LetterTileSprite[indexX, indexY], 4 )
			next indexX
		next indexY		

		for indexX = 0 to 10
			SelectedLettersTileSprite[indexX] = CreateSprite ( 41 )
			SetSpriteOffset( SelectedLettersTileSprite[indexX], (GetSpriteWidth(SelectedLettersTileSprite[indexX])/2) , (GetSpriteHeight(SelectedLettersTileSprite[indexX])/2) ) 
			SetSpritePositionByOffset( SelectedLettersTileSprite[indexX], -9999, -9999 )
			SetSpriteColorAlpha( SelectedLettersTileSprite[indexX], 255 )
			SetSpriteDepth ( SelectedLettersTileSprite[indexX], 4 )
		next indexX

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "SCORE", 999, 13, 255, 255, 0, 255, 0, 0, 0, 1, 100, 626-19, 3)
		ScoreText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, 100, 626, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "LEVEL", 999, 13, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth-100, 626-19, 3)
		LevelText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth-100, 626, 3)

		if MusicVolume > 0 or EffectsVolume > 0
			CreateIcon(1, 18, 622 )
		else
			CreateIcon(0, 18, 622 )
		endif

		CreateIcon( 4, (ScreenWidth/2), -9999 )
		SetSpriteDepth ( Icon[4], 10 )

		CreateIcon(5, 360-18, 622)
			
		CreateIcon(80, -9999, -9999)

		CreateIcon( 81, (ScreenWidth/2), 617 )
		BombsText = CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, " ", 999, 15, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), 617+5, 2 )

		CreateIcon(82, -9999, -9999)

		CreateIcon(83, -9999, -9999)
		CreateIcon(84, -9999, -9999)

		BombMeterSprite = CreateSprite ( 46 )
		SetSpriteOffset( BombMeterSprite, (GetSpriteWidth(BombMeterSprite)/2) , (GetSpriteHeight(BombMeterSprite)/2) ) 
		SetSpritePositionByOffset( BombMeterSprite, (ScreenWidth/2), (ScreenHeight-61) )
		SetSpriteScaleByOffset( BombMeterSprite, BombMeterScaleX, 1 )
		SetSpriteColorAlpha( BombMeterSprite, (255) )
		SetSpriteDepth ( BombMeterSprite, 4 )

		for indexX = 0 to 2
			FallingLettersTileSprite[indexX] = CreateSprite ( 41 )
			SetSpriteOffset( FallingLettersTileSprite[indexX], (GetSpriteWidth(FallingLettersTileSprite[indexX])/2) , (GetSpriteHeight(FallingLettersTileSprite[indexX])/2) ) 
			SetSpritePositionByOffset( FallingLettersTileSprite[indexX], -9999, -9999 )
			SetSpriteColorAlpha( FallingLettersTileSprite[indexX], 255 )
			SetSpriteDepth ( FallingLettersTileSprite[indexX], 4 )
		next indexX

		BombFallingSprite = CreateSprite ( 44 )
		SetSpriteOffset( BombFallingSprite, (GetSpriteWidth(BombFallingSprite)/2) , (GetSpriteHeight(BombFallingSprite)/2) ) 
		SetSpritePositionByOffset( BombFallingSprite, -9999, -9999 )
		SetSpriteDepth ( BombFallingSprite, 4 )

		ExplosionSprite = CreateSprite ( 47 )
		ExplosionAlpha = 0
		ExplosionScale = 0
		SetSpriteOffset( ExplosionSprite, (GetSpriteWidth(ExplosionSprite)/2) , (GetSpriteHeight(ExplosionSprite)/2) ) 
		SetSpritePositionByOffset( ExplosionSprite, (ScreenWidth/2), (ScreenHeight-61) )
		SetSpriteScaleByOffset( ExplosionSprite, ExplosionScale, ExplosionScale )
		SetSpriteColorAlpha( ExplosionSprite, (ExplosionAlpha) )
		SetSpriteDepth ( ExplosionSprite, 2 )

		NameInputCharSprite = CreateSprite ( 131 )
		SetSpriteDepth ( NameInputCharSprite, 2 )
		SetSpriteOffset( NameInputCharSprite, (GetSpriteWidth(NameInputCharSprite)/2) , (GetSpriteHeight(NameInputCharSprite)/2) ) 
		SetSpriteScaleByOffset( NameInputCharSprite, 1.2, 1.75 )
		SetSpritePositionByOffset( NameInputCharSprite, -9999, -9999 )

		GameOverSprite = CreateSprite ( 75 )
		SetSpriteDepth ( GameOverSprite, 2 )
		SetSpriteOffset( GameOverSprite, (GetSpriteWidth(GameOverSprite)/2) , (GetSpriteHeight(GameOverSprite)/2) ) 
		SetSpritePositionByOffset( GameOverSprite, -9999, -9999 )

		YouWinSprite = CreateSprite ( 149 )
		SetSpriteDepth ( YouWinSprite, 2 )
		SetSpriteOffset( YouWinSprite, (GetSpriteWidth(YouWinSprite)/2) , (GetSpriteHeight(YouWinSprite)/2) ) 
		SetSpritePositionByOffset( YouWinSprite, -9999, -9999 )

		if (GameIsPlaying = FALSE)
			SetupForNewGame()
		else
			SetupForNextLevel()
		endif

		ScreenIsDirty = TRUE

		NewLevelTextAlpha = 0
		NewLevelTextAlphaDirection = 1
		NewLevelText = CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "LEVEL "+str(Level), 999, 60, 255, 255, 255, NewLevelTextAlpha, 0, 0, 0, 1, (ScreenWidth/2), (ScreenHeight/2), 2 )
		NewLevelTextDisplayDelay = 0
		
		GamePaused = -1
		GamePausedStatus = FALSE
		
		StopSound(SoundEffect[12])
	endif

	if (NewLevelTextAlphaDirection <> -1)
		if (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
			if (Level = 10)
				SetTextStringOutlined ( NewLevelText, " " )
			elseif (Level = 9)
				SetTextStringOutlined ( NewLevelText, "Final! Level" )
			else
				SetTextStringOutlined ( NewLevelText, "LEVEL "+str(Level)+" Of 10" )
			endif
		else
			SetTextStringOutlined ( NewLevelText, "LEVEL "+str(Level) )
		endif

		if (NewLevelTextAlphaDirection = 1)
			if ( NewLevelTextAlpha < (255) )
				inc NewLevelTextAlpha, (5)
			else
				NewLevelTextAlpha = (255)
				NewLevelTextAlphaDirection = 2
			endif
		elseif (NewLevelTextAlphaDirection = 2)
			if (NewLevelTextDisplayDelay < 10)
				inc NewLevelTextDisplayDelay, 1
			else
				NewLevelTextAlphaDirection = 0
			endif
		elseif (NewLevelTextAlphaDirection = 0)
			if ( NewLevelTextAlpha > (5) )
				dec NewLevelTextAlpha, (5)
			else
				NewLevelTextAlpha = 0
				NewLevelTextDisplayDelay = 0
				NewLevelTextAlphaDirection = -1
			endif
		endif

		SetTextColorAlpha(NewLevelText, NewLevelTextAlpha)
		alphaIndex as integer
		for alphaIndex = NewLevelText to (NewLevelText+25)
			if ( GetTextExists(alphaIndex) ) then SetTextColorAlpha(alphaIndex, NewLevelTextAlpha)
		next alphaIndex
	endif

	if (GamePaused > -1)
		if (GamePaused > 0) then  dec GamePaused, 1

		if (GamePaused = 0 and MouseButtonLeft = OFF) then  GamePaused = -1
	endif

	if (GamePaused = -1)
		if ThisIconWasPressed(0) = TRUE
			if MusicVolume > 0 or EffectsVolume > 0
				SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
				IconSprite[0] = 0
				SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
				MusicVolume = 0
				EffectsVolume = 0
				SetVolumeOfAllMusicAndSoundEffects()
				GUIchanged = TRUE
			else
				SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
				IconSprite[0] = 1
				SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
				MusicVolume = 100
				EffectsVolume = 100
				SetVolumeOfAllMusicAndSoundEffects()
				GUIchanged = TRUE
			endif
			SaveOptionsAndHighScores()
		elseif ThisIconWasPressed(2) = TRUE
			if (GamePausedStatus = FALSE)
				GamePausedStatus = TRUE
				
				GamePaused = 50

				SetDelayAllUserInput(14)

				SetSpritePositionByOffset( GamePausedBG, (ScreenWidth/2), (ScreenHeight/2) )
				
				SetSpriteDepth ( Icon[0], 1 )
				SetSpriteDepth ( Icon[1], 1 )
				SetSpriteDepth ( Icon[4], 1 )
				SetSpriteDepth ( Icon[5], 1 )

				IconScreenY[1] = 622
				SetSpritePositionByOffset( Icon[4], IconScreenX[1], IconScreenY[1] )

				PauseMusicOGG(MusicTrack[CurrentlyPlayingMusicIndex])
			elseif (GamePausedStatus = TRUE)
				if (GamePaused = -1)
					GamePausedStatus = FALSE

					GamePaused = 50

					SetDelayAllUserInput(14)

					SetSpritePositionByOffset( GamePausedBG, -9999, -9999 )
					
					SetSpriteDepth ( Icon[0], 2 )
					SetSpriteDepth ( Icon[1], 2 )
					SetSpriteDepth ( Icon[4], 10 )
					SetSpriteDepth ( Icon[5], 2 )

					IconScreenY[1] = -9999
					SetSpritePositionByOffset( Icon[4], IconScreenX[1], IconScreenY[1] )
					
					ResumeMusicOGG(MusicTrack[CurrentlyPlayingMusicIndex])
				endif
			endif		
		elseif (ThisIconWasPressed(1) = TRUE)
			QuitGame = TRUE
			NextScreenToDisplay = TitleScreen
			PlayNewMusic(0, 1)
			GameOverTimer = 0
			ScreenFadeStatus = FadingToBlack
		endif
	endif

	if (GameOverTimer = -1)
		if (GamePausedStatus = FALSE and GamePaused = -1)
			if (GameStatus = PlayingGame)
				if (CheckWordColorTimer > 0)
					dec CheckWordColorTimer, 1
				else
					CheckWordRed = 255
					CheckWordGreen = 255
					CheckWordBlue = 255
					SetSpriteColorRed( Icon[82], CheckWordRed )
					SetSpriteColorGreen( Icon[82], CheckWordGreen )
					SetSpriteColorBlue( Icon[82], CheckWordBlue )
				
					CheckWordColorTimer = 0
				endif

				DisplayPlayfield()
				
				RunGameplayCore()
							
				SetTextStringOutlined ( ScoreText, str(Score) )
				
				if (Level < 9 or GameMode = ChildNeverEndMode or GameMode = TeenNeverEndMode or GameMode = AdultNeverEndMode)
					SetTextStringOutlined ( LevelText, str(Level) )
				else
					SetTextStringOutlined ( LevelText, "Final!" )
				endif
				
				SetTextStringOutlined ( BombsText, str(Bombs) )

				if (SelectedLetterWordIndex > 1)
					IconScreenX[5] = (ScreenWidth/2)
					IconScreenY[5] = 545-1
					SetSpritePositionByOffset( Icon[82], IconScreenX[5], IconScreenY[5] )
				else
					IconScreenX[5] = -9999
					IconScreenY[5] = -9999
					SetSpritePositionByOffset( Icon[82], IconScreenX[5], IconScreenY[5] )
				endif

				if (NextFallingIsBomb = 1)
					IconScreenX[6] = (37/2)+2
					IconScreenY[6] = 545-1
					SetSpritePositionByOffset( Icon[83], IconScreenX[6], IconScreenY[6] )
					IconScreenX[7] = ScreenWidth-(37/2)-2
					IconScreenY[7] = 545-1
					SetSpritePositionByOffset( Icon[84], IconScreenX[7], IconScreenY[7] )
				else
					IconScreenX[6] = -9999
					IconScreenY[6] = -9999
					SetSpritePositionByOffset( Icon[83], IconScreenX[6], IconScreenY[6] )
					IconScreenX[7] = -9999
					IconScreenY[7] = -9999
					SetSpritePositionByOffset( Icon[84], IconScreenX[7], IconScreenY[7] )
				endif

				if ThisIconWasPressed(3) = TRUE
					if (SelectedLetterWordIndex > -1)
						PlaySoundEffect(3)
						SetSpriteColor( LetterTileSprite[ SelectedLettersPlayfieldX[SelectedLetterWordIndex], SelectedLettersPlayfieldY[SelectedLetterWordIndex] ], 255, 255, 255, 255 )
						
						SetText(SelectedLettersTextIndex[SelectedLetterWordIndex+1], " ")
								
						SelectedLetters[SelectedLetterWordIndex+1] = "1"

						SetSpritePositionByOffset( SelectedLettersTileSprite[SelectedLetterWordIndex], -9999, -9999 )

						dec SelectedLetterWordIndex, 1

						if (SelectedLetterWordIndex > -1)
							IconScreenX[3] = (  ( (31/2)+9 ) + (9+1)*31  )
							IconScreenY[3] = 509
							SetSpritePositionByOffset( Icon[80], IconScreenX[3], IconScreenY[3] )
						else
							IconScreenX[3] = -9999
							IconScreenY[3] = -9999
							SetSpritePositionByOffset( Icon[80], IconScreenX[3], IconScreenY[3] )
						endif

						MouseButtonLeft = OFF
						MouseButtonLeftJustClicked = -1
						FingerPlayfieldX = -1
						FingerPlayfieldY = -1
					endif
				elseif ThisIconWasPressed(4) = TRUE
					if (Bombs > 0 and NextFallingIsBomb = 0)
						NextFallingIsBomb = 2
						FallingLettersAfterBombMovePlayfieldX = FallingLettersPlayfieldX[0]
						BombHitPlayfieldX = (FallingLettersPlayfieldX[0])
						inc BombHitPlayfieldX, 1
						if (BombHitPlayfieldX > 10) then BombHitPlayfieldX = 0
						PlaySoundEffect(4)
						dec Bombs, 1

						EraseChosenLetters()
					endif
				elseif ThisIconWasPressed(5) = TRUE
					CheckSelectedLettersForWord()
				elseif ThisIconWasPressed(6) = TRUE
					if (NextFallingIsBomb = 1)
						if (FallingLettersPlayfieldX[0] > 0)
							if (Playfield[FallingLettersPlayfieldX[0]-1, FallingLettersPlayfieldY[0]] = "1")
								dec FallingLettersPlayfieldX[0], 1
								dec BombHitPlayfieldX, 1
							endif
						endif
					endif
				elseif ThisIconWasPressed(7) = TRUE
					if (NextFallingIsBomb = 1)
						if (FallingLettersPlayfieldX[0] < 10)
							if (Playfield[FallingLettersPlayfieldX[0]+1, FallingLettersPlayfieldY[0]] = "1")
								inc FallingLettersPlayfieldX[0], 1
								inc BombHitPlayfieldX, 1
							endif
						endif
					endif
				endif
			elseif (GameStatus = ClearingWord)
				PlayfieldIsDirty = TRUE
				ScreenIsDirty = TRUE

				if (CorrectWordTileAndCharAlpha > 51)
					dec CorrectWordTileAndCharAlpha, 51 
				elseif (CorrectWordTileAndCharAlpha > 0 and CorrectWordTileAndCharAlpha < 52)
					CorrectWordTileAndCharAlpha = 0
				elseif (CorrectWordTileAndCharAlpha = 0)
					EraseCorrectWord()
					CorrectWordTileAndCharAlpha = 255
					
					GameStatus = ApplyingGravity
				endif
				
				DisplayPlayfield()
			elseif (GameStatus = ApplyingGravity)
				PlayfieldIsDirty = TRUE
				ScreenIsDirty = TRUE

				if ( ApplyGravityToPlayfield() = FALSE ) then  GameStatus = PlayingGame
				
				DisplayPlayfield()
			endif
		endif
	elseif (GameOverTimer > 1)
		dec GameOverTimer, 1

		if (WonGame = FALSE)
			SetSpritePositionByOffset( YouWinSprite, -9999, -9999 )
			SetSpritePositionByOffset( GameOverSprite, (ScreenWidth/2), (ScreenHeight/2) )
		elseif (WonGame = TRUE)
			SetSpritePositionByOffset( GameOverSprite, -9999, -9999 )
			SetSpritePositionByOffset( YouWinSprite, (ScreenWidth/2), (ScreenHeight/2) )
		endif
	elseif (GameOverTimer = 1)
		GameOverTimer = 0
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
		if (QuitGame = FALSE)
			if (GameIsPlaying = TRUE)
				if (GameOverTimer = -1 and Level = 5)
					NextScreenToDisplay = FiveSceneScreen
					DelayAllUserInput = 30
				else
					CheckPlayerForHighScore()
					if (WonGame = FALSE)
						if (PlayerRankOnGameOver < 10)
							PlayNewMusic(7, 1)
							if (OnMobile = TRUE)
								NextScreenToDisplay = NewHighScoreNameInputAndroidScreen
							else
								NextScreenToDisplay = NewHighScoreNameInputScreen
							endif
						else	
							NextScreenToDisplay = HighScoresScreen
							PlayNewMusic(0, 1)
						endif
					elseif (WonGame = TRUE)
						NextScreenToDisplay = AboutScreen
					endif
				endif
			endif
		endif
	endif
endfunction

//------------------------------------------------------------------------------------------------------------
// BROKEN
function DisplayNewHighScoreNameInputScreen ( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		PreRenderCharacterIconTexts()

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''N E W   H I G H   S C O R E''", 999, 28, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "You Achieved A New High Score!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Enter Your Name!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25, 3)

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 130 )
		SetSpriteColor(ScreenLine[1], 255, 255, 255, 255)

		NewHighScoreCurrentName = ""
		NewHighScoreNameIndex = 0

		NewNameText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 30, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 185, 3)
		SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, 240 )
		SetSpriteColor(ScreenLine[2], 255, 255, 255, 255)

		screenX as integer
		screenX = 18
		screenY as integer
		screenY = 310
		indexX as integer
		indexY as integer
		index as integer
		index = 10
		for indexY = 0 to 4
			for indexX = 0 to 12
				CreateIcon( index, (screenX+(indexX*27)), (screenY+(indexY*48)) )
				
				inc index, 1
			next indexX
		next indexY

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 5, (ScreenWidth / 2), (ScreenHeight-40+15) )

		NextScreenToDisplay = HighScoresScreen

		ScreenIsDirty = TRUE
	endif

	shiftAddition as integer
	shiftAddition = 0
	if ShiftKeyPressed = FALSE then inc shiftAddition, 26
	
	if DelayAllUserInput = 0
		index = LastKeyboardChar
		if (LastKeyboardChar >= 65 and LastKeyboardChar <= 90)
			IconAnimationTimer[ (index-65) + shiftAddition ] = 2
			CurrentIconBeingPressed = index

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[(index-65) + 10 + shiftAddition]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif (LastKeyboardChar >= 48 and LastKeyboardChar <= 57)
			IconAnimationTimer[ (index+4) ] = 2
			CurrentIconBeingPressed = index

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[index+4+10]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif LastKeyboardChar = 32
			IconAnimationTimer[26+37] = 2
			CurrentIconBeingPressed = 26+37

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[26+37+10]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif LastKeyboardChar = 107
			IconAnimationTimer[72-10] = 2
			CurrentIconBeingPressed = 72

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[72]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif LastKeyboardChar = 8
			IconAnimationTimer[26+38] = 2
			CurrentIconBeingPressed = 26+38

			CurrentKeyboardKeyPressed = index
		else
			if (CurrentKeyboardKeyPressed > -1) then dec CurrentKeyboardKeyPressed, 1
		endif
	endif

	for index = 0 to 63
		if ThisIconWasPressed(index) and CurrentKeyboardKeyPressed = -1 and NewHighScoreNameIndex < 9
			inc NewHighScoreNameIndex, 1
			NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[10+index]
		endif
	next index

	if ThisIconWasPressed(64)
		SetDelayAllUserInput(14)
		if NewHighScoreNameIndex > 0 then dec NewHighScoreNameIndex, 1
		NewHighScoreCurrentName = left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	if NewHighScoreNameIndex > 9
		NewHighScoreNameIndex = 9
		NewHighScoreCurrentName= left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	if ThisButtonWasPressed(5) = TRUE
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
		HighScoreName [ GameMode, PlayerRankOnGameOver ] = NewHighScoreCurrentName
		SaveOptionsAndHighScores()
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayNewHighScoreNameInputAndroidScreen ( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		PreRenderCharacterIconTexts()

		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		NameInputCharSpriteChar = 999
		MouseButtonLeftWasReleased = FALSE

		NameInputCharSprite = CreateSprite ( 131 )
		SetSpriteDepth ( NameInputCharSprite, 2 )
		SetSpriteOffset( NameInputCharSprite, (GetSpriteWidth(NameInputCharSprite)/2) , (GetSpriteHeight(NameInputCharSprite)/2) ) 
		SetSpritePositionByOffset( NameInputCharSprite, -9999, -9999 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''N E W   H I G H   S C O R E''", 999, 28, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "You Achieved A New High Score!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Enter Your Name!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25, 3)

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 130 )
		SetSpriteColor(ScreenLine[1], 255, 255, 255, 255)

		NewHighScoreCurrentName = ""
		NewHighScoreNameIndex = 0

		NewNameText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 30, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 185, 3)
		SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, 240 )
		SetSpriteColor(ScreenLine[2], 255, 255, 255, 255)

		screenX as integer
		screenX = 18
		screenY as integer
		screenY = 310
		indexX as integer
		indexY as integer
		index as integer
		index = 10
		for indexY = 0 to 4
			for indexX = 0 to 12
				CreateIcon( index, (screenX+(indexX*27)), (screenY+(indexY*48)) )
				
				inc index, 1
			next indexX
		next indexY

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 5, (ScreenWidth / 2), (ScreenHeight-40+15) )

		NextScreenToDisplay = HighScoresScreen

		ScreenIsDirty = TRUE
	endif

	for index = 0 to 63
		if ThisIconWasPressedAndroid(index)
			SetDelayAllUserInput(14)
			inc NewHighScoreNameIndex, 1
			NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[10+index]
		endif
	next index

	if ThisIconWasPressedAndroid(64)
		SetDelayAllUserInput(14)
		if NewHighScoreNameIndex > 0 then dec NewHighScoreNameIndex, 1
		NewHighScoreCurrentName = left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	if NewHighScoreNameIndex > 9
		NewHighScoreNameIndex = 9
		NewHighScoreCurrentName= left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	shiftAddition as integer
	shiftAddition = 0
	if ShiftKeyPressed = FALSE then inc shiftAddition, 26
		if DelayAllUserInput = 0
			
		for index = 65 to 90
			if LastKeyboardChar = index
				IconAnimationTimer[ (index-65) + shiftAddition ] = 3//10
				PlaySoundEffect(1)
				SetDelayAllUserInput(4)
			endif
		next index

		for index = 48 to 57
			if LastKeyboardChar = index
				IconAnimationTimer[ (index+4) ] = 3//10
				PlaySoundEffect(1)
				SetDelayAllUserInput(4)
			endif
		next index

		if LastKeyboardChar = 107
			IconAnimationTimer[26+36] = 3//10
			PlaySoundEffect(1)
			SetDelayAllUserInput(4)
		elseif LastKeyboardChar = 32
			IconAnimationTimer[26+37] = 3//10
			PlaySoundEffect(1)
			SetDelayAllUserInput(4)

		elseif LastKeyboardChar = 8
			IconAnimationTimer[26+38] = 3//10
			PlaySoundEffect(1)
			SetDelayAllUserInput(4)
		endif
	endif

	if ThisButtonWasPressed(5) = TRUE
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
		HighScoreName [ GameMode, PlayerRankOnGameOver ] = NewHighScoreCurrentName
		SaveOptionsAndHighScores()
	endif
endfunction
	
//------------------------------------------------------------------------------------------------------------

function DisplayIntroSceneScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		ActOneBG = CreateSprite ( 150 )
		SetSpriteDepth ( ActOneBG, 2 )
		SetSpriteOffset( ActOneBG, (GetSpriteWidth(ActOneBG)/2) , (GetSpriteHeight(ActOneBG)/2) ) 
		SetSpritePositionByOffset( ActOneBG, (ScreenWidth/2), (ScreenHeight/2) )

		ActOneBoyScreenX = 90-300
		ActOneBoy = CreateSprite ( 151 )
		SetSpriteDepth ( ActOneBoy, 2 )
		SetSpriteOffset( ActOneBoy, (GetSpriteWidth(ActOneBoy)/2) , (GetSpriteHeight(ActOneBoy)/2) ) 
		SetSpriteScaleByOffset( ActOneBoy, .7, .7 )
		SetSpritePositionByOffset( ActOneBoy, ActOneBoyScreenX, (ScreenHeight/2) )

		ActOneGirlScreenX = (ScreenWidth-50)+300
		ActOneGirl = CreateSprite ( 152 )
		SetSpriteDepth ( ActOneGirl, 2 )
		SetSpriteOffset( ActOneGirl, (GetSpriteWidth(ActOneGirl)/2) , (GetSpriteHeight(ActOneGirl)/2) ) 
		SetSpriteScaleByOffset( ActOneGirl, .6, .6 )
		SetSpritePositionByOffset( ActOneGirl, ActOneGirlScreenX, (ScreenHeight/2) )

		ActOneTextBox = CreateSprite ( 153 )
		SetSpriteDepth ( ActOneTextBox, 2 )
		SetSpriteOffset( ActOneTextBox, (GetSpriteWidth(ActOneTextBox)/2) , (GetSpriteHeight(ActOneTextBox)/2) ) 
		SetSpritePositionByOffset( ActOneTextBox, (ScreenWidth/2), (ScreenHeight-76) )

		PlayNewMusic(8, 1)

		ActOneAnimationStep = 0

		ActOneBoyText = "Boy: Hi...Wanna hang out?"
		ActOneBoyTextIndex = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 17, 200, 200, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 535, 2)
		ActOneBoyTextToDisplay = 0
		ActOneGirlText = "Girl: Win the game and I'll give you a surprise!"
		ActOneGirlTextIndex = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 17, 255, 200, 200, 255, 0, 0, 0, 1, ScreenWidth/2, 535+50, 2)
		ActOneGirlTextToDisplay = 0

		ActOneTextDisplayTimer = 0

		DelayAllUserInput = 30

		ScreenIsDirty = TRUE
	endif

	if (ActOneAnimationStep = 0)
		inc ActOneBoyScreenX, 6
		SetSpritePositionByOffset( ActOneBoy, ActOneBoyScreenX, (ScreenHeight/2) )
		dec ActOneGirlScreenX, 6
		SetSpritePositionByOffset( ActOneGirl, ActOneGirlScreenX, (ScreenHeight/2) )

		ScreenIsDirty = TRUE
		
		if (ActOneBoyScreenX > 80)
			inc ActOneAnimationStep, 1
			PlaySoundEffect(12)
		endif
	elseif (ActOneAnimationStep = 1)
		if (ActOneTextDisplayTimer < 5)
			inc ActOneTextDisplayTimer, 1
		else
			inc ActOneBoyTextToDisplay, 1
			SetTextStringOutlined ( ActOneBoyTextIndex, left(ActOneBoyText, ActOneBoyTextToDisplay) )
			
			if ( ActOneBoyTextToDisplay = len(ActOneBoyText) ) then inc ActOneAnimationStep, 1
			
			ActOneTextDisplayTimer = 0
		endif
	elseif (ActOneAnimationStep = 2)
		if (ActOneTextDisplayTimer < 5)
			inc ActOneTextDisplayTimer, 1
		else
			inc ActOneGirlTextToDisplay, 1
			SetTextStringOutlined ( ActOneGirlTextIndex, left(ActOneGirlText, ActOneGirlTextToDisplay) )
			
			if ( ActOneGirlTextToDisplay = len(ActOneGirlText) )
				inc ActOneAnimationStep, 1
				StopSound(SoundEffect[12]) 
			endif
			
			ActOneTextDisplayTimer = 0
		endif
	elseif (ActOneAnimationStep = 3)
		if (ActOneTextDisplayTimer < 200)
			inc ActOneTextDisplayTimer, 1
		else
			MouseButtonLeft = ON
		endif
	endif

	if (MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27)
		StopSound(SoundEffect[12]) 
		NextScreenToDisplay = PlayingScreen
		ScreenFadeStatus = FadingToBlack
		if (ActOneAnimationStep < 3) then PlaySoundEffect(1)
		SetDelayAllUserInput(14)
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayFiveSceneScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		ActTwoBG = CreateSprite ( 154 )
		SetSpriteDepth ( ActTwoBG, 2 )
		SetSpriteOffset( ActTwoBG, (GetSpriteWidth(ActTwoBG)/2) , (GetSpriteHeight(ActTwoBG)/2) ) 
		SetSpritePositionByOffset( ActTwoBG, (ScreenWidth/2), (ScreenHeight/2) )

		ActTwoBoyAlpha = 0
		ActTwoBoy = CreateSprite ( 155 )
		SetSpriteDepth ( ActTwoBoy, 2 )
		SetSpriteOffset( ActTwoBoy, (GetSpriteWidth(ActTwoBoy)/2) , (GetSpriteHeight(ActTwoBoy)/2) )
		SetSpriteColorAlpha ( ActTwoBoy, ActTwoBoyAlpha )
		SetSpriteScaleByOffset( ActTwoBoy, 1, 1.1 )
		SetSpritePositionByOffset( ActTwoBoy, (ScreenWidth/2), (0+(GetSpriteHeight(ActTwoBoy)/2)) )

		ActTwoGirlAlpha = 0
		ActTwoGirl = CreateSprite ( 156 )
		SetSpriteDepth ( ActTwoGirl, 2 )
		SetSpriteOffset( ActTwoGirl, (GetSpriteWidth(ActTwoGirl)/2) , (GetSpriteHeight(ActTwoGirl)/2) ) 
		SetSpriteColorAlpha ( ActTwoGirl, ActTwoGirlAlpha )
		SetSpriteScaleByOffset( ActTwoGirl, 1, 1.1 )
		SetSpritePositionByOffset( ActTwoGirl, (ScreenWidth/2), (0+(GetSpriteHeight(ActTwoGirl)/2)) )

		ActTwoTextBox = CreateSprite ( 157 )
		SetSpriteDepth ( ActTwoTextBox, 2 )
		SetSpriteOffset( ActTwoTextBox, (GetSpriteWidth(ActTwoTextBox)/2) , (GetSpriteHeight(ActTwoTextBox)/2) ) 
		SetSpritePositionByOffset( ActTwoTextBox, (ScreenWidth/2), (ScreenHeight-76) )

		ActTwoAnimationStep = 0

		ActTwoBoyText = "Boy: Half way there!"
		ActTwoBoyTextIndex = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 17, 200, 200, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 535, 2)
		ActTwoBoyTextToDisplay = 0
		ActTwoGirlText = "Girl: Focus on the game so you don't lose!"
		ActTwoGirlTextIndex = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 17, 255, 200, 200, 255, 0, 0, 0, 1, ScreenWidth/2, 535+50, 2)
		ActTwoGirlTextToDisplay = 0

		ActTwoTextDisplayTimer = 0

		DelayAllUserInput = 30

		ScreenIsDirty = TRUE

		PlayNewMusic(9, 1)
	endif

	if (ActTwoAnimationStep = 0)
		if (ActTwoBoyAlpha < 255)
			inc ActTwoBoyAlpha, 5
			SetSpriteColorAlpha ( ActTwoBoy, ActTwoBoyAlpha )
		else
			ActTwoBoyAlpha = 255
			SetSpriteColorAlpha ( ActTwoBoy, ActTwoBoyAlpha )
			PlaySoundEffect(12)
			inc ActTwoAnimationStep, 1
		endif
	elseif (ActTwoAnimationStep = 1)
		if (ActTwoTextDisplayTimer < 5)
			inc ActTwoTextDisplayTimer, 1
		else
			inc ActTwoBoyTextToDisplay, 1
			SetTextStringOutlined ( ActTwoBoyTextIndex, left(ActTwoBoyText, ActTwoBoyTextToDisplay) )
			
			if ( ActTwoBoyTextToDisplay = len(ActTwoBoyText) ) then inc ActTwoAnimationStep, 1
			
			ActTwoTextDisplayTimer = 0
		endif
	elseif (ActTwoAnimationStep = 2)
		if (ActTwoBoyAlpha > 0)
			dec ActTwoBoyAlpha, 5
			SetSpriteColorAlpha ( ActTwoBoy, ActTwoBoyAlpha )
		else
			ActTwoBoyAlpha = 0
			SetSpriteColorAlpha ( ActTwoBoy, ActTwoBoyAlpha )
			inc ActTwoAnimationStep, 1
		endif
	elseif (ActTwoAnimationStep = 3)
		if (ActTwoGirlAlpha < 255)
			inc ActTwoGirlAlpha, 5
			SetSpriteColorAlpha ( ActTwoGirl, ActTwoGirlAlpha )
		else
			ActTwoGirlAlpha = 255
			SetSpriteColorAlpha ( ActTwoGirl, ActTwoGirlAlpha )
			PlaySoundEffect(12)
			inc ActTwoAnimationStep, 1
		endif
	elseif (ActTwoAnimationStep = 4)
		if (ActTwoTextDisplayTimer < 5)
			inc ActTwoTextDisplayTimer, 1
		else
			inc ActTwoGirlTextToDisplay, 1
			SetTextStringOutlined ( ActTwoGirlTextIndex, left(ActTwoGirlText, ActTwoGirlTextToDisplay) )
			
			if ( ActTwoGirlTextToDisplay = len(ActTwoGirlText) )
				inc ActTwoAnimationStep, 1
				StopSound(SoundEffect[12]) 
			endif
			
			ActTwoTextDisplayTimer = 0
		endif
	elseif (ActTwoAnimationStep = 5)
		if (ActTwoTextDisplayTimer < 200)
			inc ActTwoTextDisplayTimer, 1
		else
			MouseButtonLeft = ON
		endif
	endif

	if (MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27)
		StopSound(SoundEffect[12]) 
		NextScreenToDisplay = PlayingScreen
		ScreenFadeStatus = FadingToBlack
		if (ActTwoAnimationStep < 5) then PlaySoundEffect(1)
		SetDelayAllUserInput(14)
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
		PlayNewMusic(3, 1)
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayExitScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )

		if CurrentlyPlayingMusicIndex > -1 then StopMusicOGG(MusicTrack[CurrentlyPlayingMusicIndex])
		
		BlackBG = CreateSprite ( 2 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "This Game Is M.I.T. Open-Source!", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, 22, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Click The Icons Below", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, 22+30, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "To Get The Free Source Code", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, 22+30+30, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "& The AppGameKit Game Engine:", 999, 25, 0, 0, 0, 255, 220, 220, 220, 1, ScreenWidth/2, 22+30+30+30, 3)

		CreateIcon( 98, (ScreenWidth / 2), (ScreenHeight/2)-110+40 )
		CreateIcon( 99, (ScreenWidth / 2), (ScreenHeight/2)+110+40 )

		CreateButton( 5, (ScreenWidth / 2), (ScreenHeight-40+15) )

		ScreenIsDirty = TRUE
	endif

	if ThisButtonWasPressed(5) = TRUE
		if Platform = Web
			OpenBrowser( "https://fallenangelsoftware.com" )
		else
			ExitGame = 1
		endif
	endif

	if ThisIconWasPressed(0) = TRUE
		OpenBrowser( "https://github.com/FallenAngelSoftware/AppGameKit-LettersFall" )
	endif

	if ThisIconWasPressed(1) = TRUE
		OpenBrowser( "https://store.steampowered.com/app/1024640/AppGameKit_Studio/" )
	endif

	if ScreenFadeStatus = FadingToBlack and ScreenFadeTransparency = 254
		
	endif
endfunction
