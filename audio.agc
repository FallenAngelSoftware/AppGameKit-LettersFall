// "audio.agc"...

function LoadAllSoundEffects ( )
	if (UseMP3andWAV = FALSE)
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
	elseif (UseMP3andWAV = TRUE)
		SoundEffect[ 0] = LoadSound("\media\sound\MenuMove.wav")
		SoundEffect[ 1] = LoadSound("\media\sound\MenuClick.wav")
		SoundEffect[ 2] = LoadSound("\media\sound\LetterClick.wav")
		SoundEffect[ 3] = LoadSound("\media\sound\Undo.wav")
		SoundEffect[ 4] = LoadSound("\media\sound\BombLaunched.wav")
		SoundEffect[ 5] = LoadSound("\media\sound\Explosion.wav")
		SoundEffect[ 6] = LoadSound("\media\sound\WordGood.wav")
		SoundEffect[ 7] = LoadSound("\media\sound\WordBad.wav")
		SoundEffect[ 8] = LoadSound("\media\sound\BombUp.wav")
		SoundEffect[ 9] = LoadSound("\media\sound\LevelUp.wav")
		SoundEffect[10] = LoadSound("\media\sound\GameOver.wav")
		SoundEffect[11] = LoadSound("\media\sound\Heart.wav")
		SoundEffect[12] = LoadSound("\media\sound\Typing.wav")
		SoundEffect[13] = LoadSound("\media\sound\PlayfieldRise.wav")
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function LoadAllMusic ( )
	if (UseMP3andWAV = FALSE)
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
	elseif (UseMP3andWAV = TRUE)
		MusicTrack[ 0] = LoadMusic( "\media\music\Title-BGM.lite.mp3" )
		MusicTrack[ 1] = LoadMusic( "\media\music\Track1-BGM.lite.mp3" )
		MusicTrack[ 2] = LoadMusic( "\media\music\Track2-BGM.lite.mp3" )
		MusicTrack[ 3] = LoadMusic( "\media\music\Track3-BGM.lite.mp3" )
		MusicTrack[ 4] = LoadMusic( "\media\music\Track4-BGM.lite.mp3" )
		MusicTrack[ 5] = LoadMusic( "\media\music\Track5-BGM.lite.mp3" )
		MusicTrack[ 6] = LoadMusic( "\media\music\NeverEnd-BGM.lite.mp3" )
		MusicTrack[ 7] = LoadMusic( "\media\music\HighScore-BGM.lite.mp3" )
		MusicTrack[ 8] = LoadMusic( "\media\music\CutScene1-BGM.lite.mp3" )
		MusicTrack[ 9] = LoadMusic( "\media\music\CutScene2-BGM.lite.mp3" )
		MusicTrack[10] = LoadMusic( "\media\music\CutScene3-BGM.lite.mp3" )
		MusicTrack[11] = LoadMusic( "\media\music\WinChild-BGM.mp3" )
		MusicTrack[12] = LoadMusic( "\media\music\WinTeen-BGM.mp3" )
		MusicTrack[13] = LoadMusic( "\media\music\WinAdult-BGM.mp3" )
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function SetVolumeOfAllMusicAndSoundEffects()
	SetSoundSystemVolume(EffectsVolume) 	
	
	index as integer
	for index = 0 to (MusicTotal-1)
		if (UseMP3andWAV = FALSE)
			SetMusicVolumeOGG( MusicTrack[index], MusicVolume )
		elseif (UseMP3andWAV = TRUE)
			SetMusicFileVolume( MusicTrack[index], MusicVolume )
		endif
	next index
endfunction

//------------------------------------------------------------------------------------------------------------

function PlayNewMusic ( index as integer, loopMusic as integer )
	if ( index > (MusicTotal-1) ) then exitfunction
	
	if (UseMP3andWAV = FALSE)
		if CurrentlyPlayingMusicIndex > -1 then StopMusicOGG(MusicTrack[CurrentlyPlayingMusicIndex])
		PlayMusicOGG( MusicTrack[index], loopMusic )
	elseif (UseMP3andWAV = TRUE)
		if CurrentlyPlayingMusicIndex > -1 then StopMusic()
		PlayMusic( MusicTrack[index], loopMusic )
	endif
	
	CurrentlyPlayingMusicIndex = index
endfunction

//------------------------------------------------------------------------------------------------------------

function PlaySoundEffect ( index as integer )
	if ( index > (EffectsTotal-1) ) then exitfunction
	
	PlaySound(SoundEffect[index])
endfunction
