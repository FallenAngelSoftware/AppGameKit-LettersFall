// "audio.agc"...

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

function LoadAllSoundEffects ( )
	SoundEffect[ 0] = LoadSoundOGG("\media\sound\MenuMove.ogg")
	SoundEffect[ 1] = LoadSoundOGG("\media\sound\MenuClick.ogg")
	SoundEffect[ 2] = LoadSoundOGG("\media\sound\LetterClick.ogg")
	SoundEffect[ 3] = LoadSoundOGG("\media\sound\Undo.ogg")
	SoundEffect[ 4] = LoadSoundOGG("\media\sound\BombLaunched.ogg")
	SoundEffect[ 5] = LoadSoundOGG("\media\sound\Explosion.ogg")
	SoundEffect[ 6] = LoadSoundOGG("\media\sound\WordGood.ogg")
	SoundEffect[ 7] = LoadSoundOGG("\media\sound\WordBad.ogg")
	SoundEffect[ 8] = LoadSoundOGG("\media\sound\BombUp.ogg")
	SoundEffect[ 9] = LoadSoundOGG("\media\sound\LevelUp.ogg")
	SoundEffect[10] = LoadSoundOGG("\media\sound\GameOver.ogg")
	SoundEffect[11] = LoadSoundOGG("\media\sound\Heart.ogg")
	SoundEffect[12] = LoadSoundOGG("\media\sound\Typing.ogg")
	SoundEffect[13] = LoadSoundOGG("\media\sound\PlayfieldRise.ogg")
endfunction

//------------------------------------------------------------------------------------------------------------

function LoadAllMusic ( )
	MusicTrack[ 0] = LoadMusicOGG( "\media\music\Title-BGM.lite.ogg" )
	MusicTrack[ 1] = LoadMusicOGG( "\media\music\Track1-BGM.lite.ogg" )
	MusicTrack[ 2] = LoadMusicOGG( "\media\music\Track2-BGM.lite.ogg" )
	MusicTrack[ 3] = LoadMusicOGG( "\media\music\Track3-BGM.lite.ogg" )
	MusicTrack[ 4] = LoadMusicOGG( "\media\music\Track4-BGM.lite.ogg" )
	MusicTrack[ 5] = LoadMusicOGG( "\media\music\Track5-BGM.lite.ogg" )
	MusicTrack[ 6] = LoadMusicOGG( "\media\music\NeverEnd-BGM.lite.ogg" )
	MusicTrack[ 7] = LoadMusicOGG( "\media\music\HighScore-BGM.lite.ogg" )
	MusicTrack[ 8] = LoadMusicOGG( "\media\music\CutScene1-BGM.lite.ogg" )
	MusicTrack[ 9] = LoadMusicOGG( "\media\music\CutScene2-BGM.lite.ogg" )
	MusicTrack[10] = LoadMusicOGG( "\media\music\CutScene3-BGM.lite.ogg" )
	MusicTrack[11] = LoadMusicOGG( "\media\music\WinChild-BGM.ogg" )
	MusicTrack[12] = LoadMusicOGG( "\media\music\WinTeen-BGM.ogg" )
	MusicTrack[13] = LoadMusicOGG( "\media\music\WinAdult-BGM.ogg" )
endfunction

//------------------------------------------------------------------------------------------------------------

function SetVolumeOfAllMusicAndSoundEffects()
	SetSoundSystemVolume(EffectsVolume) 	
	
	index as integer
	for index = 0 to (MusicTotal-1)
		SetMusicVolumeOGG( MusicTrack[index], MusicVolume )
	next index
endfunction

//------------------------------------------------------------------------------------------------------------

function PlayNewMusic ( index as integer, loopMusic as integer )
	if ( index > (MusicTotal-1) ) then exitfunction
	
	if CurrentlyPlayingMusicIndex > -1 then StopMusicOGG(MusicTrack[CurrentlyPlayingMusicIndex])
	PlayMusicOGG( MusicTrack[index], loopMusic )
	
	CurrentlyPlayingMusicIndex = index
endfunction

//------------------------------------------------------------------------------------------------------------

function PlaySoundEffect ( index as integer )
	if ( index > (EffectsTotal-1) ) then exitfunction
	
	PlaySound(SoundEffect[index])
endfunction
