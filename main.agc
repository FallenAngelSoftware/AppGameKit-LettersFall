// "main.agc"...

remstart
---------------------------------------------------------------------------------------------------
                                           JeZxLee's
                                                                   TM
                             AppGameKit Classic "NightRider" Engine
                                        (Version 1.9.1)
   _              _     _                         _____          _   _     _   _    ___    _  __TM
  | |       ___  | |_  | |_    ___   _ __   ___  |  ___|  __ _  | | | |   / | / |  / _ \  (_)/ /
  | |      / _ \ | __| | __|  / _ \ | '__| / __| | |_    / _` | | | | |   | | | | | | | |   / /
  | |___  |  __/ | |_  | |_  |  __/ | |    \__ \ |  _|  | (_| | | | | |   | | | | | |_| |  / /_
  |_____|  \___|  \__|  \__|  \___| |_|    |___/ |_|     \__,_| |_| |_|   |_| |_|  \___/  /_/(_)

                                     Retail2 110% - v6.2.6              "Turbo!"

---------------------------------------------------------------------------------------------------     

           Google Android SmartPhones/Tablets & HTML5 Desktop/Notebook Internet Browsers

---------------------------------------------------------------------------------------------------                       

                     (C)opyright 2019, By Team "www.FallenAngelSoftware.com"

---------------------------------------------------------------------------------------------------
remend

#include "audio.agc"
#include "data.agc"
#include "input.agc"
#include "interface.agc"
#include "logic.agc"
#include "screens.agc"
#include "visuals.agc"

global DictionaryLetterLoading as integer

global GameVersion as string
GameVersion = "''Retail2 110% - Turbo! - v6.2.6''"
global DataVersion as string
DataVersion = "LF110-Retail2-110-Turbo-v6_2_1.cfg"
global HTML5DataVersion as String
HTML5DataVersion = "LF6-v6_2_1-"

global MaximumFrameRate as integer
MaximumFrameRate = 0

global PerformancePercent as float

#option_explicit
SetErrorMode(2)

global ScreenWidth = 360
global ScreenHeight = 640
global ExitGame as integer
ExitGame = 0

SetWindowTitle( "LettersFall 110%[TM]" )
SetWindowSize( ScreenWidth, ScreenHeight, 0 )
SetWindowAllowResize( 1 )

SetScreenResolution( ScreenWidth, ScreenHeight ) 
SetVirtualResolution( ScreenWidth, ScreenHeight )
SetOrientationAllowed( 1, 0, 0, 0 )

#constant FALSE		0
#constant TRUE		1

global UseMP3andWAV as integer
UseMP3andWAV = FALSE

#constant Web		0
#constant Android	1
#constant iOS		2
#constant Windows	3
global Platform as integer

global OnMobile as integer
global ShowCursor as integer
if ( GetDeviceBaseName() = "android" or GetDeviceBaseName() = "ios" )
	if ( GetDeviceBaseName() = "android" )
		Platform = Android
	elseif ( GetDeviceBaseName() = "ios" )
		Platform = iOS
	endif

	SetImmersiveMode(1) 

	SetSyncRate( 30, 0 )
	SetScissor( 0,0,0,0 )
	SetVirtualResolution( ScreenWidth, ScreenHeight) //+40 )
	OnMobile = TRUE
	ShowCursor = FALSE	
else
	if ( GetDeviceBaseName() = "html5" ) then UseMP3andWAV = TRUE
		
	Platform = Web
	SetVSync( 1 )
	SetScissor( 0, 0, ScreenWidth, ScreenHeight )
	OnMobile = FALSE
	ShowCursor = TRUE
endif

if (GetDeviceBaseName() = "windows" or GetDeviceBaseName() = "linux") then Platform = Windows

global GameUnlocked as integer
GameUnlocked = 2

global LoadPercent as float
global LoadPercentFixed as integer

// Uncomment below three lines to test Android version on desktop																			
// Platform = Android
// OnMobile = TRUE
// ShowCursor = FALSE

SetClearColor( 0, 0, 0 ) 
ClearScreen()

global FingerPlayfieldX as integer
global FingerPlayfieldY as integer

global GameIsPlaying as integer
GameIsPlaying = FALSE

LoadImage ( 75, "\media\images\backgrounds\GameOver.png" )
global GameOverTimer as integer

global GameOverSprite as integer

global PlayfieldIsDirty as integer

global FallingLetterSpeed as float[6]
global FallingLetterDecimalCounter as float

global DictionaryMemBlock as integer[26]
global DictionaryString as String[0,0]
DictionaryString.length = 26
global CurrentWordSelected as string
global CheckWordRed as integer
global CheckWordGreen as integer
global CheckWordBlue as integer
global CheckWordColorTimer as integer

global LevelAdvanceCounter as integer
global WonGame as integer

global NewLevelText as integer
global NewLevelTextAlpha as integer
global NewLevelTextAlphaDirection as integer
global NewLevelTextDisplayDelay as integer

#constant PlayingGame				1
#constant ClearingWord				2
#constant ApplyingGravity			3
global GameStatus = PlayingGame

global CorrectWordTileAndCharAlpha as integer

global MouseScreenX = 0
global MouseScreenY = 0
#constant OFF						0
#constant ON						1
global MouseButtonLeft = OFF
global MouseButtonLeftJustClicked as integer
global MouseButtonLeftReleased as integer
MouseButtonLeftReleased = TRUE
global MouseButtonRight = OFF
global MouseButtonRightJustClicked as integer
global MouseButtonRightReleased as integer
MouseButtonRightReleased = TRUE

global ShiftKeyPressed as integer
ShiftKeyPressed = FALSE

#constant JoyCENTER			0
#constant JoyUP				1
#constant JoyRIGHT			2
#constant JoyDOWN     		3
#constant JoyLEFT			4
global JoystickDirection as integer
JoystickDirection = JoyCENTER

global JoystickButtonOne as integer
JoystickButtonOne = OFF
global JoyButtonOneReleased as integer
JoyButtonOneReleased = TRUE
global JoystickButtonTwo as integer
JoystickButtonTwo = OFF
global JoyButtonTwoReleased as integer
JoyButtonTwoReleased = TRUE

global KeyboardControls as integer

global LastKeyboardChar = -1

global DelayAllUserInput as integer
DelayAllUserInput = 0

#constant FadingIdle		-1
#constant FadingFromBlack 	 0
#constant FadingToBlack 	 1
global ScreenFadeStatus as integer
ScreenFadeStatus = FadingFromBlack
global ScreenFadeTransparency as integer
ScreenFadeTransparency = 255

global BlackBG as integer
global FadingBlackBG as integer
LoadImage ( 1, "\media\images\backgrounds\FadingBlackBG.png" )
FadingBlackBG = CreateSprite ( 1 )
SetSpriteDepth ( FadingBlackBG, 1 )
SetSpriteOffset( FadingBlackBG, (GetSpriteWidth(FadingBlackBG)/2) , (GetSpriteHeight(FadingBlackBG)/2) ) 
SetSpritePositionByOffset( FadingBlackBG, ScreenWidth/2, ScreenHeight/2 )
SetSpriteTransparency( FadingBlackBG, 1 )

UseNewDefaultFonts( 1 )
LoadFont( 999, "\media\fonts\FreeSansBold.ttf" )
global CurrentMinTextIndex = 1

LoadImage ( 3, "\media\images\backgrounds\FadingBlackBG.png" )
global Resume as integer

LoadImage ( 5, "\media\images\logos\AppGameKitLogo.png" )
global AppGameKitLogo as integer

LoadImage ( 8, "\media\images\story\Act3of3\bg.png" )
LoadImage ( 9, "\media\images\story\Act3of3\char.png" )
global Kiss as integer

LoadImage ( 10, "\media\images\backgrounds\TitleBG.png" )
LoadImage ( 20, "\media\images\backgrounds\TitleBlurBG.png" )
LoadImage ( 11, "\media\images\backgrounds\TitleTwoBG.png" )
LoadImage ( 21, "\media\images\backgrounds\TitleTwoBlurBG.png" )
LoadImage ( 12, "\media\images\backgrounds\TitleThreeBG.png" )
LoadImage ( 22, "\media\images\backgrounds\TitleThreeBlurBG.png" )
LoadImage ( 13, "\media\images\backgrounds\TitleFourBG.png" )
LoadImage ( 23, "\media\images\backgrounds\TitleFourBlurBG.png" )
global TitleBG as integer

LoadSelectedBackground()

LoadImage (30, "\media\images\logos\FAS-Statue.png")
global SixteenBitSoftLogo as integer

LoadImage ( 35, "\media\images\logos\LF110-Logo.png" )
global LF110Logo as integer

global NewNameText as integer
global NewHighScoreCurrentName as String
NewHighScoreCurrentName = " "
global NewHighScoreNameIndex as integer
NewHighScoreNameIndex = 1

global PauseGame as integer
PauseGame = FALSE

#constant SteamOverlayScreen						0
#constant AppGameKitScreen							1
#constant SixteenBitSoftScreen						2
#constant TitleScreen								3
#constant OptionsScreen								4
#constant HowToPlayScreen							5
#constant HighScoresScreen							6
#constant AboutScreen								7
#constant IntroSceneScreen							8
#constant PlayingScreen								9
#constant FiveSceneScreen							10
#constant NewHighScoreNameInputScreen				11
#constant NewHighScoreNameInputAndroidScreen		12
#constant MusicPlayerScreen							13
global ScreenToDisplay = 3
if (OnMobile = FALSE) then ScreenToDisplay = 0
global NextScreenToDisplay = 4
global ScreenDisplayTimer = 0

global ClickToContinueText as integer

global MusicPlayerScreenIndex as integer
MusicPlayerScreenIndex = 0

global LeftArrow
LoadImage ( 100, "\media\images\gui\ButtonSelectorLeft.png" )
global RightArrow
LoadImage ( 101, "\media\images\gui\ButtonSelectorRight.png" )

LoadImage ( 103, "\media\images\gui\Button.png" )
global ButtonText as string[8]
ButtonText[0] = "START!"
ButtonText[1] = "Options"
ButtonText[2] = "How To Play"
ButtonText[3] = "High Scores"
ButtonText[4] = "About"
ButtonText[5] = "Exit"
ButtonText[6] = "Back"
ButtonText[7] = "Clear Scores"

global ButtonSprite as integer[8]
for index = 0 to 7
	ButtonSprite[index] = 680+index
next index

global ButtonIndex as integer[8]
global ButtonScreenX as integer[8]
global ButtonScreenY as integer[8]
global ButtonAnimationTimer as integer[8]
global ButtonScale as float[8]
global NumberOfButtonsOnScreen = 0
global ButtonSelectedByKeyboard = 0
index as integer
for index = 0 to 7
    ButtonIndex[index] = -1
    ButtonScreenX[index] = (ScreenWidth/2)
    ButtonScreenY[index] = (ScreenHeight/2)
    ButtonAnimationTimer[index] = 0
    ButtonScale[index] = 1
next index

LoadImage ( 120, "\media\images\gui\ButtonSelectorRight.png" )
LoadImage ( 121, "\media\images\gui\ButtonSelectorLeft.png" )
global LeftArrowSet as integer[10]
global RightArrowSet as integer[10]

LoadImage ( 122, "\media\images\gui\SelectorLine.png" )
global SelectorLine as integer

LoadImage ( 130, "\media\images\gui\NameInputButton.png" )

LoadImage ( 131, "\media\images\gui\NameInputChar.png" )
global NameInputCharSprite as integer
global NameInputCharSpriteChar as integer
global MouseButtonLeftWasReleased as integer

global NumberOfArrowSetsOnScreen as integer = 0
global ArrowSetSelectedByKeyboard as integer = 0
global ArrowSetScreenY as integer[10]
global ArrowSetLeftAnimationTimer as integer[10]
global ArrowSetRightAnimationTimer as integer[10]
global ArrowSetLeftScale as float[10]
global ArrowSetRightScale as float[10]
global ArrowSetTextStringIndex as integer[10]
for index = 0 to 9
    ArrowSetScreenY[index] = (ScreenHeight/2)
    ArrowSetLeftAnimationTimer[index] = 0
    ArrowSetRightAnimationTimer[index] = 0
    ArrowSetLeftScale[index] = 1
    ArrowSetRightScale[index] = 1
    ArrowSetTextStringIndex[index] = -1
next index

LoadImage ( 140, "\media\images\gui\ScreenLine.png" )
global ScreenLine as integer[10]

global Icon as integer[100]
LoadImage ( 300, "\media\images\gui\SpeakerOFF.png" )
LoadImage ( 301, "\media\images\gui\SpeakerON.png" )
LoadImage ( 302, "\media\images\logos\GooglePlayLogo.png" )
LoadImage ( 303, "\media\images\logos\ReviewGooglePlayLogo.png" )
LoadImage ( 304, "\media\images\gui\Exit.png" )
LoadImage ( 305, "\media\images\gui\Pause.png" )
LoadImage ( 306, "\media\images\gui\Play.png" )
LoadImage ( 307, "\media\images\logos\OptionsBanner.png" )

LoadImage ( 43, "\media\images\playing\UndoArrow.png" )

LoadImage ( 44, "\media\images\playing\Bomb.png" )

LoadImage ( 45, "\media\images\playing\CheckWordSmaller.png" )

LoadImage ( 50, "\media\images\gui\BombLeft.png" )
LoadImage ( 51, "\media\images\gui\BombRight.png" )

global IconIndex as integer[100]
global IconSprite as integer[100]
global IconScreenX as integer[100]
global IconScreenY as integer[100]
global IconAnimationTimer as integer[100]
global IconScale as float[100]
global IconText as string[100]
global NumberOfIconsOnScreen as integer
NumberOfIconsOnScreen = 0
for index = 0 to 99
	IconIndex[index] = -1
    IconSprite[index] = -1
    IconScreenX[index] = (ScreenWidth/2)
    IconScreenY[index] = (ScreenHeight/2)
    IconAnimationTimer[index] = 0
    IconScale[index] = 1
    IconText[index] = " "
next index

LoadInterfaceSprites()
PreRenderButtonsWithTexts()

global CurrentlyPlayingMusicIndex = -1
#constant MusicTotal 						14
global MusicTrack as integer[MusicTotal]
LoadAllMusic()

#constant EffectsTotal						14
global SoundEffect as integer[EffectsTotal]
LoadAllSoundEffects()

global MusicSoundtrack	as integer
MusicSoundtrack = 0

#constant ChildStoryMode				0
#constant TeenStoryMode					1
#constant AdultStoryMode				2
#constant ChildNeverEndMode				3
#constant TeenNeverEndMode				4
#constant AdultNeverEndMode				5
global GameMode = AdultStoryMode

global MusicVolume as integer
MusicVolume = 100
global EffectsVolume as integer
EffectsVolume = 100

global SecretCode as integer[4]
SecretCode[0] = 0
SecretCode[1] = 0
SecretCode[2] = 0
SecretCode[3] = 0
global SecretCodeCombined as integer
SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
global HowToPlayLegend as integer
global HowToPlayFingerTouch as integer[4]

global PlayerLostALife as integer
PlayerLostALife = FALSE

global GameOver as integer
GameOver = 0

global PlayerRankOnGameOver as integer
PlayerRankOnGameOver = 999

global GameWon as integer
GameWon = FALSE

mode as integer
global HighScoreName as string[5, 10]
global HighScoreLevel as integer[5, 10]
global HighScoreScore as integer[5, 10]

global LevelSkip as integer[5]
LevelSkip[0] = 0
LevelSkip[1] = 0
LevelSkip[2] = 0
LevelSkip[3] = 0
LevelSkip[4] = 0
LevelSkip[5] = 0
global StartingLevel as integer
StartingLevel = 0

ClearHighScores()

global AboutTexts as string[99999]
global AboutTextsScreenY as integer[99999]
global AboutTextsBlue as integer[99999]
for index = 0 to 99998
	AboutTexts[index] = "Should Not See"
	AboutTextsScreenY[index] = 99999
	AboutTextsBlue[index] = 255
next index

global ATindex = 0

global NumberOfAboutScreenTexts
NumberOfAboutScreenTexts = ATindex
global StartIndexOfAboutScreenTexts
StartIndexOfAboutScreenTexts = 0

global AboutScreenOffsetY as float
global AboutScreenBackgroundY as float
global AboutScreenFPSY as float
AboutScreenFPSY = -200

global AboutScreenTextFrameSkip as integer

LoadAboutScreenTexts()

global ChangingBackground as integer
ChangingBackground = FALSE
global SelectedBackground as integer
SelectedBackground = 0

global Score as integer
global ScoreText as integer
global Level as integer
global LevelText as integer
global Bombs as integer
global BombsText as integer

global Playfield as string[11, 19]
global PlayfieldLetterTextIndex as integer[11, 19]

global SelectedLetterWordIndex as integer

global SelectedLettersTextIndex as integer[12]
global SelectedLettersPlayfieldX as integer[12]
global SelectedLettersPlayfieldY as integer[12]
global SelectedLetters as string[12]

global FallingLettersAfterBombMovePlayfieldX as integer
FallingLettersAfterBombMovePlayfieldX = -1

LoadImage ( 40, "\media\images\backgrounds\PlayfieldBG.png" )
global PlayfieldSprite as integer

LoadImage ( 41, "\media\images\playing\LetterTile.png" )
global LetterTileSprite as integer[11, 19]
global SelectedLettersTileSprite as integer[11]

LoadImage ( 42, "\media\images\backgrounds\GamePausedBG.png" )
global GamePausedBG as integer
global GamePaused as integer

LoadImage ( 46, "\media\images\playing\BombMeter.png" )
global BombMeterSprite as integer
global BombMeterScaleX as float

global BombFallingSprite as integer
global BombHitPlayfieldX as integer
global BombHitPlayfieldY as integer

LoadImage ( 47, "\media\images\playing\Explosion.png" )
global ExplosionSprite as integer
global ExplosionScale as float
global ExplosionAlpha as integer
global NextFallingIsBomb as integer

global FallingLettersCount as integer
global FallingLettersTileSprite as integer[3]
global FallingLettersLetter as string[3]
global FallingLettersPlayfieldX as integer[3]
global FallingLettersPlayfieldY as integer[3]
global FallingLettersScreenY as integer[3]
global FallingLettersScreenYstep as integer[3]
global FallingLettersTextIndex as integer[3]

global HowToPlayWordsTileSprite as integer[5]

LoadImage ( 48, "\media\images\backgrounds\HowToPlayBG.png" )
global HowToPlayBG as integer

LoadImage ( 49, "\media\images\gui\ArrowIcon.png" )
global ArrowIconSprite as integer
global ArrowIconAnimationStep as integer
global ArrowIconAnimationDelay as integer

LoadImage ( 149, "\media\images\backgrounds\YouWin.png" )
global YouWinSprite as integer

LoadImage ( 150, "\media\images\story\Act1of3\bg.png" )
global ActOneBG as integer
LoadImage ( 151, "\media\images\story\Act1of3\boy.png" )
global ActOneBoy as integer
global ActOneBoyScreenX as integer
LoadImage ( 152, "\media\images\story\Act1of3\girl.png" )
global ActOneGirl as integer
global ActOneGirlScreenX as integer
LoadImage ( 153, "\media\images\story\Act1of3\TextBox.png" )
global ActOneTextBox as integer
global ActOneAnimationStep as integer
global ActOneBoyText as string
global ActOneBoyTextIndex as integer
global ActOneBoyTextToDisplay as integer
global ActOneGirlText as string
global ActOneGirlTextIndex as integer
global ActOneGirlTextToDisplay as integer
global ActOneTextDisplayTimer as integer

LoadImage ( 154, "\media\images\story\Act2of3\bg-b.png" )
global ActTwoBG as integer
LoadImage ( 155, "\media\images\story\Act2of3\boy.png" )
global ActTwoBoy as integer
global ActTwoBoyAlpha as integer
LoadImage ( 156, "\media\images\story\Act2of3\girl.png" )
global ActTwoGirl as integer
global ActTwoGirlAlpha as integer
LoadImage ( 157, "\media\images\story\Act2of3\TextBox.png" )
global ActTwoTextBox as integer
global ActTwoAnimationStep as integer
global ActTwoBoyText as string
global ActTwoBoyTextIndex as integer
global ActTwoBoyTextToDisplay as integer
global ActTwoGirlText as string
global ActTwoGirlTextIndex as integer
global ActTwoGirlTextToDisplay as integer
global ActTwoTextDisplayTimer as integer

global FrameCount as integer
FrameCount = 0
global SecondsSinceStart as integer
SecondsSinceStart = 0

global QuitPlaying as integer
QuitPlaying = FALSE

global GUIchanged as integer
GUIchanged = TRUE

global roundedFPS as float

SetPrintColor ( 255, 255, 255 )
SetPrintSize(17)

global PrintColor as integer
PrintColor = 255
global PrintColorDir as integer
PrintColorDir = 0

global FPSChangeDelay as integer

global FramesPerSecond as integer
FramesPerSecond = 30

LoadOptionsAndHighScores()
SetVolumeOfAllMusicAndSoundEffects()

SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )

global ScreenIsDirty as integer
ScreenIsDirty = TRUE

global LoadPercentText as integer

global FrameSkip as integer

global QuitGame as integer

if (OnMobile = TRUE) then  PlayNewMusic(0, 1)

global CurrentIconBeingPressed as integer
CurrentIconBeingPressed = -1
global CurrentKeyboardKeyPressed as integer
CurrentKeyboardKeyPressed = -1

global multiplier as float

global GamePausedStatus as integer

do
	inc FrameCount, 1
		
	GetAllUserInput()
	
	select ScreenToDisplay
		case SteamOverlayScreen:
			DisplaySteamOverlayScreen()
		endcase

		case AppGameKitScreen:
			DisplayAppGameKitScreen()
		endcase

		case SixteenBitSoftScreen:
			DisplaySixteenBitSoftScreen()
		endcase

		case TitleScreen:
			DisplayTitleScreen()
		endcase

		case OptionsScreen:
			DisplayOptionsScreen()
		endcase

		case HowToPlayScreen:
			DisplayHowToPlayScreen()
		endcase

		case HighScoresScreen:
			DisplayHighScoresScreen()
		endcase

		case AboutScreen:
			DisplayAboutScreen()
		endcase

		case IntroSceneScreen:
			DisplayIntroSceneScreen()
		endcase

		case PlayingScreen:
			DisplayPlayingScreen()
		endcase

		case FiveSceneScreen:
			DisplayFiveSceneScreen()
		endcase

		case NewHighScoreNameInputScreen:
			DisplayNewHighScoreNameInputScreen()
		endcase

		case NewHighScoreNameInputAndroidScreen:
			DisplayNewHighScoreNameInputAndroidScreen()
		endcase

		case MusicPlayerScreen:
			DisplayMusicPlayerScreen()
		endcase
	endselect

	if (GUIchanged = TRUE or ScreenToDisplay = NewHighScoreNameInputAndroidScreen)
		if NumberOfButtonsOnScreen > 0 then DrawAllButtons()
		if NumberOfIconsOnScreen > 0 then DrawAllIcons()
	
		ScreenIsDirty = TRUE
		GUIchanged = FALSE
	endif

	if ScreenFadeStatus <> FadingIdle
		ScreenIsDirty = TRUE
		ApplyScreenFadeTransition()
	endif

	roundedFPS = Round( ScreenFPS() )

	if (roundedFPS > 0)
		PerformancePercent = (60 / roundedFPS)
	else
		PerformancePercent = 1
	endif

	if (FrameCount > roundedFPS)
		FrameCount = 0
		
		if (OnMobile = TRUE)
			if (  ( GetDeviceWidth() <> 360 ) or ( GetDeviceHeight() <> 640 )  )
				SetImmersiveMode(1)
			endif
		endif
				
		inc SecondsSinceStart, 1
	endif

	if (SecretCodeCombined = 2777 and ScreenIsDirty = TRUE)
		if (ScreenFadeStatus = FadingIdle)
			if (ScreenToDisplay = AboutScreen)
				SetSpritePositionByOffset( FadingBlackBG,  -80, AboutScreenFPSY )
			else
				SetSpritePositionByOffset( FadingBlackBG,  -80, -200 )
			endif			
			SetSpriteColorAlpha( FadingBlackBG, 200 )
		else
			SetSpritePositionByOffset( FadingBlackBG,  ScreenWidth/2, ScreenHeight/2 )
		endif
		
		if (PrintColorDir = 0)
			if (PrintColor > 0)
				dec PrintColor, 51
			else
				PrintColor = 0
				PrintColorDir = 1
			endif
		elseif (PrintColorDir = 1)
			if (PrintColor < 255)
				inc PrintColor, 51
			else
				PrintColor = 255
				PrintColorDir = 0
			endif
		endif
		
		SetPrintColor (PrintColor, PrintColor, PrintColor)
		Print ( "FPS="+str(roundedFPS) )
		print (  "Sprite(s): "+str( GetManagedSpriteCount() )  )
		print ( Platform )
		print ( "GamePaused:"+str(GamePaused) )
		print ( "PauseStat:"+str(GamePausedStatus) )
		print ( "IconPressed:"+str(CurrentIconBeingPressed) )
	endif

	if (ScreenIsDirty = TRUE)
		Sync()
		ScreenIsDirty = TRUE
	endif

	if ExitGame = 1
		exit
	endif
loop
rem                                      [TM]
rem "A 110% By Team Fallen Angel Software!"
