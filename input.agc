// "input.agc"...

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

function GetAllUserInput ( )
	MouseButtonLeft = OFF
	MouseButtonRight = OFF
	LastKeyboardChar = -1
	ShiftKeyPressed = FALSE
	JoystickDirection = JoyCENTER
	JoystickButtonOne = OFF
	JoystickButtonTwo = OFF	
	
	if (DelayAllUserInput > 0)
		dec DelayAllUserInput, 1
		exitfunction
	endif

	if GetRawKeyState(16) = 1 then ShiftKeyPressed = TRUE

	if (OnMobile = FALSE)
		MouseScreenX = GetRawMouseX()
		MouseScreenY = GetRawMouseY()

		if ( GetRawMouseLeftState() )
			if (MouseButtonLeftReleased = TRUE)
				MouseButtonLeft = ON
				MouseButtonLeftJustClicked = 0
				MouseButtonLeftReleased = FALSE
			endif
		else
			MouseButtonLeftReleased = TRUE
		endif

		if ( GetRawMouseRightState() )
			if (MouseButtonRightReleased = TRUE)
				MouseButtonRight = ON
				MouseButtonRightJustClicked = 0
				MouseButtonRightReleased = FALSE
			endif
		else
			MouseButtonRightReleased = TRUE
		endif
	elseif (OnMobile = TRUE)
		MouseScreenX = GetPointerX() / GetMaxDeviceWidth() * 360.0
		MouseScreenY = GetPointerY() / GetMaxDeviceHeight() * 640.0

		if ( GetPointerState() = 1 )
			MouseButtonLeft = ON
			MouseButtonLeftJustClicked = 0
		else
			MouseButtonLeft = OFF
		endif
	endif

	if (MouseButtonLeft = OFF and MouseButtonLeftJustClicked = 0)
		MouseButtonLeftJustClicked = 1
	elseif (MouseButtonLeft = OFF and MouseButtonLeftJustClicked = 1)
		MouseButtonLeftJustClicked = -1
	endif

	index as integer
	for index = 1 to 255
		if GetRawKeyState(index) = 1
			LastKeyboardChar = index
		endif
	next index

	select LastKeyboardChar
		case 38:
			JoystickDirection = JoyUP
		endcase
		case 39:
			JoystickDirection = JoyRIGHT
		endcase
		case 40:
			JoystickDirection = JoyDOWN
		endcase
		case 37:
			JoystickDirection = JoyLEFT
		endcase
	endselect
	
	if LastKeyboardChar = 27
		SetDelayAllUserInput(14)
		PlayNewMusic(0, 1)
		QuitPlaying = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	endif
endfunction
