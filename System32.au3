#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=System32.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <DateTimeConstants.au3>
#include <GuiTreeView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#include <DateTimeConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <string.au3>
#include <misc.au3>
#include <Array.au3>

Opt("WinTitleMatchMode", 3)

Global $IniFile = "Settings.ini"

;If Not FileExists($IniFile) Then
	;FileInstall("Encrypted.ini", "Settings.ini", 1)
;	UNPW()
;Else;
;	UNPW()
;EndIf
BuildGUI()
CheckSettings()
;GUISetState(@SW_SHOW, $MainGUI)
$Win_Error = 1
$ExitMainWhile = 0
$DND_Check = 0
$Cast = 0
$Found = 0
$Caught = 0
$beep = 0
;GUICtrlSetData($Main_Status_lbl, "Ready")
Main_While()

#Region UNPW
#cs
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Game Data in Encryted in the settings.ini file [Encryption], DO NOT FORGET your password.
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func UNPW()
	$P_List = ProcessList()
	$Ran_P = Random(1, $P_List[0][0], 1); Random 1- Max Process
	$MainGUI = GUICreate($P_List[$Ran_P][0], 260, 90, -1, -1)
	GUISetFont(9, 800, 0, "MS Sans Serif")
	$WindowDisplay01 = GUICtrlCreateLabel("Enter User Name.", 10, 5, 150, 20)
	$WindowDisplay1 = GUICtrlCreateInput("Please", 145, 5, 100, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
	$WindowDisplay02 = GUICtrlCreateLabel("Enter Password.", 10, 27, 150, 20)
	$WindowDisplay2 = GUICtrlCreateInput("Change", 145, 27, 100, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_PASSWORD))
	$WindowDisplay03 = GUICtrlCreateButton("Enter", 145, 50, 100, 20, $BS_DEFPUSHBUTTON)
	$WindowDisplay3 = GUICtrlCreateButton("Next", 145, 50, 100, 20)
	GUICtrlSetState($WindowDisplay3, $gui_Hide)
	$WindowDisplay003 = GUICtrlCreateButton("Encrypt", 145, 50, 100, 20)
	GUICtrlSetState($WindowDisplay003, $gui_Hide)
	$WindowDisplay04 = GUICtrlCreateButton("Change", 15, 50, 100, 20)
	$WindowDisplay4 = GUICtrlCreateProgress(0, 75, 260, 15, $PBS_SMOOTH)
	GUISetState()
	While 1
		$Msg = GUIGetMsg()
		Select
			Case $Msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $Msg = $WindowDisplay03; Compare user name and password with encrypted data in Settings.ini
				If _StringEncrypt(1, _StringEncrypt(1, GUICtrlRead($WindowDisplay1), GUICtrlRead($WindowDisplay2), 1), IniRead($IniFile, "Encryption", "Sub1", Default), 1) = IniRead($IniFile, "Encryption", "Main", Default) Then
					Global $UNPW = _StringEncrypt(1, GUICtrlRead($WindowDisplay1), GUICtrlRead($WindowDisplay2), 1)
					Decrypt($UNPW, $WindowDisplay4)
					GUIDelete($MainGUI)
					ExitLoop
				ElseIf Not FileExists($IniFile) Then
					MsgBox(0, "Mssing File", "Missing the Settings.ini file.", 3)
					Exit
				Else
					If Not WinExists("Encryption", "") Then
						MsgBox(0, "Encryption [1]", "Incorrect !", 3)
					EndIf
				EndIf
			Case $Msg = $WindowDisplay04
				GUICtrlSetState($WindowDisplay3, $gui_Show)
				GUICtrlSetState($WindowDisplay03, $gui_Hide)
				GUICtrlSetState($WindowDisplay04, $gui_Disable)
				GUICtrlSetData($WindowDisplay01, "Enter OLD User Name")
				GUICtrlSetColor($WindowDisplay01, 0x800000)
				GUICtrlSetData($WindowDisplay02, "Enter OLD Password")
				GUICtrlSetColor($WindowDisplay02, 0x800000)
			Case $Msg = $WindowDisplay3
				If _StringEncrypt(1, _StringEncrypt(1, GUICtrlRead($WindowDisplay1), GUICtrlRead($WindowDisplay2), 1), IniRead($IniFile, "Encryption", "Sub1", Default), 1) = IniRead($IniFile, "Encryption", "Main", Default) Then
					$OLDUNPW = _StringEncrypt(1, GUICtrlRead($WindowDisplay1), GUICtrlRead($WindowDisplay2), 1)
					GUICtrlSetState($WindowDisplay3, $gui_Hide)
					GUICtrlSetState($WindowDisplay003, $gui_Show)
					GUICtrlSetState($WindowDisplay04, $gui_Disable)
					GUICtrlSetData($WindowDisplay01, "Enter NEW User Name")
					GUICtrlSetColor($WindowDisplay01, 0x008000)
					GUICtrlSetData($WindowDisplay02, "Enter NEW Password")
					GUICtrlSetColor($WindowDisplay02, 0x008000)
					GUICtrlSetData($WindowDisplay1, "")
					GUICtrlSetData($WindowDisplay2, "")
				ElseIf Not FileExists($IniFile) Then
					MsgBox(0, "Mssing File", "Missing the Settings.ini file.", 3)
					Exit
				Else
					If Not WinExists("Encryption", "") Then
						MsgBox(0, "Encryption [2]", "Incorrect !", 3)
					EndIf
				EndIf
			Case $Msg = $WindowDisplay003
				Global $UNPW = _StringEncrypt(1, GUICtrlRead($WindowDisplay1), GUICtrlRead($WindowDisplay2), 1)
				GUICtrlSetState($WindowDisplay003, $gui_Disable)
				$var = IniReadSection($IniFile, "Encryption")
				If @error Then
					MsgBox(4096, "", "Error occurred, probably no INI file.")
				Else
					For $i = 1 To $var[0][0]
						If $var[$i][0] = "Sub1" Then
							IniWrite($IniFile, "Encryption", "Main", _StringEncrypt(1, _StringEncrypt(1, GUICtrlRead($WindowDisplay1), GUICtrlRead($WindowDisplay2), 1), IniRead($IniFile, "Encryption", "Sub1", Default), 1))
						ElseIf $var[$i][0] <> "Main" Then
							IniWrite($IniFile, "Encryption", $var[$i][0], _StringEncrypt(1, _StringEncrypt(0, IniRead($IniFile, "Encryption", $var[$i][0], Default), $OLDUNPW, 1), $UNPW, 1))
						EndIf
						GUICtrlSetData($WindowDisplay4, $i)
					Next
					GUIDelete($MainGUI)
					Decrypt($UNPW, $WindowDisplay4)
					ExitLoop
				EndIf
			Case Else
		EndSelect
	WEnd
EndFunc   ;==>UNPW
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Decryted game data from the settings.ini file [Encryption], DO NOT FORGET your password.
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func Decrypt($UNPW, $WindowDisplay4)
	GUICtrlSetData($WindowDisplay4, 0)
	Sleep(Random(10,50))
	Global Const $E_Bobber = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Bobber", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 5)
	Sleep(Random(10,50))
	Global Const $E_Bobber2 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Bobber2", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 10)
	Sleep(Random(10,50))
	Global Const $E_ToDo = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Todo", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 20)
	Sleep(Random(10,50))
	Global Const $E_ToDo2 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Todo2", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 25)
	Sleep(Random(10,50))
	Global Const $E_ToDo3 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Todo3", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 30)
	Sleep(Random(10,50))
	Global Const $E_ToDo4 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Todo4", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 35)
	Sleep(Random(10,50))
	Global Const $E_Title = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Title", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 40)
	Sleep(Random(10,50))
	Global Const $E_Title2 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Title2", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 45)
	Sleep(Random(10,50))
	Global Const $E_Locate1 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Locate1", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 50)
	Sleep(Random(10,50))
	Global Const $E_Locate2 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Locate2", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 55)
	Sleep(Random(10,50))
	Global Const $E_Locate3 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Locate3", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 60)
	Sleep(Random(10,50))
	Global Const $E_Mode_ = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Mode", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 65)
	Sleep(Random(10,50))
	Global Const $E_Mode_1 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Mode1", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 70)
	Sleep(Random(10,50))
	Global Const $E_Mode_2 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Mode2", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 75)
	Sleep(Random(10,50))
	Global Const $E_Mode_3 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Mode3", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 80)
	Sleep(Random(10,50))
	Global Const $E_Mode_4 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Mode4", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 85)
	Sleep(Random(10,50))
	Global Const $E_Mode_5 = _StringEncrypt(0, IniRead($IniFile, "Encryption", "Mode5", Default), $UNPW, 1)
	GUICtrlSetData($WindowDisplay4, 100)
	Sleep(Random(10,50))
EndFunc   ;==>Decrypt
#ce
#EndRegion UNPW
#Region BuildGUI
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Build GUI
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func BuildGUI()
	Global $E_Title = "World of Warcraft", $E_Title2 = "Wow", $E_ToDo = "<'))><", $E_ToDo1 = "<'))><", $E_ToDo2 = "<'))><", $E_Bobber = "Bobber"
	Global $E_Mode_ = "Mode 0",$E_Mode_1 = "Mode 1",$E_Mode_2 = "Mode 2",$E_Mode_3 = "Mode 3",$E_Mode_4 = "Mode 4",$E_Mode_5 = "Mode 5"
	$P_List = ProcessList()
	$Ran_P = Random(1, $P_List[0][0], 1); Random 1- Max Process
	Global $MainGUI = GUICreate($P_List[$Ran_P][0], 260, 275, -1, -1, $WS_OVERLAPPEDWINDOW, $WS_EX_TOPMOST)
	$MainTab = GUICtrlCreateTab(-1, 3, 265, 245)
	GUISetFont(9, 800, 0, "MS Sans Serif")
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; GUI CONTROLS
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Global $Start_btn = GUICtrlCreateButton("Start", 3, 252, 65, 20, 0)
	GUICtrlSetTip(-1, "Start "&$E_ToDo)
	Global $Stop_btn = GUICtrlCreateButton("Stop", 3, 252, 65, 20, 0)
	GUICtrlSetTip(-1, "Stop "&$E_ToDo)
	GUICtrlSetState($Stop_btn, $gui_Hide)
	Global $About_btn = GUICtrlCreateButton("About", 70, 252, 50, 20)
	GUICtrlSetTip(-1, "About")
	Global $Help_btn = GUICtrlCreateButton("?", 122, 252, 20, 20)
	GUICtrlSetTip(-1, "Help")
	Global $WinMode_cbx = GUICtrlCreateCheckbox("Windowed Mode", 145, 252, 120, 20)
	GUICtrlSetTip($WinMode_cbx, "Uncheck if you play in Fullscreen Mode.")
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; GUI Display
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Global $WindowDisplay = GUICtrlCreateInput($E_Title2 & " not Found", 145, 3, 110, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
	GUICtrlSetTip(-1, $E_Title)
	GUICtrlSetColor($WindowDisplay, 0x800000)
	#Region Tab1
		$Tab1 = GUICtrlCreateTabItem("Main")
		GUICtrlCreateGroup("<'))><", 1, 25, 260, 205)
		;==> GUI Line 40
		Global $Main_Untill_cbx = GUICtrlCreateCheckbox("<'))>< untill:", 5, 45, 80, 20)
		Global $Main_Untill_Time = GUICtrlCreateDate("", 90, 45, 100, 20, $DTS_TIMEFORMAT)
		Global $CurrentTime = GUICtrlCreateDate("", 190, 44, 100, 20, $DTS_TIMEFORMAT)
		GUICtrlSetState($CurrentTime,$gui_Hide)
		Global $Main_cbx = GUICtrlCreateCheckbox("Alarm", 200, 45, 80, 20)
		;==> GUI Line 65
		Global $MainStart_lbl = GUICtrlCreateLabel("Start Time: ", 05, 70, 70, 20)
		Global $Main_Start_lbl = GUICtrlCreateLabel("----", 80, 70, 120, 20)
		;==> GUI Line 95
		Global $MainTimer1_lbl = GUICtrlCreateLabel($E_ToDo&" Timer:", 05, 90, 80, 20)
		Global $Main_Timer_lbl = GUICtrlCreateLabel("---", 90, 90, 25, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $MainTimer2_lbl = GUICtrlCreateLabel(" >= ", 115, 90, 25, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $Main_MAXTimer_inp = GUICtrlCreateInput("25", 145, 88, 40, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		GUICtrlCreateUpdown($Main_MAXTimer_inp)
		Global $MainTimer3_lbl = GUICtrlCreateLabel("Seconds", 185, 92, 50, 20)
		;==> GUI Line 115
		Global $MainColor_lbl = GUICtrlCreateLabel($E_Bobber&" Color", 05, 115, 75, 20)
		Global $Main_Shades_inp = GUICtrlCreateInput("0", 90, 115, 30, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $MainShade_lbl = GUICtrlCreateLabel("Color Adjust", 125, 118, 80, 15)
		Global $Main_MaxShades_inp = GUICtrlCreateInput("60", 200, 115, 50, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		GUICtrlCreateUpdown($Main_MaxShades_inp)
		;==> GUI Line 135
		Global $Main_Color_lbl = GUICtrlCreateLabel("", 05, 130, 75, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $SS_SUNKEN))
		Global	$Main_Slider_sld = GUICtrlCreateSlider(90, 135, 160, 15)
		GUICtrlSetLimit($Main_Slider_sld, 255, 0)
		;==> GUI Line 160
		;Global $Main_Splash_rdo = GUICtrlCreateRadio("Wait for Splash", 05, 155, 120, 20)
		;Global $Main_Bobber_rdo = GUICtrlCreateRadio("Wait for Bobber", 130, 155, 130, 20)
		Global $Main_Area_lbl = GUICtrlCreateLabel("Left: ----  Top: ----  Right: ----  Bottom: ----", 05, 160, 250, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetState($Main_Area_lbl, $gui_Hide)
		;==> GUI Line 180
		Global $MainCast_lbl = GUICtrlCreateLabel("Cast:", 05, 180, 30, 20)
		Global $Main_Cast_lbl = GUICtrlCreateLabel("-----", 38, 180, 25, 20)
		Global $MainBobber_lbl = GUICtrlCreateLabel($E_Bobber&" Found:", 65, 180, 90, 20)
		Global $Main_Bobber_lbl = GUICtrlCreateLabel("-----", 153, 180, 25, 20)
		Global $MainCaught_lbl = GUICtrlCreateLabel("Caught:", 180, 180, 50, 20)
		Global $Main_Caught_lbl = GUICtrlCreateLabel("-----", 230, 180, 25, 20)
		;==> GUI Line 200
		Global $MainAccuracy1_lbl = GUICtrlCreateLabel("Current Accuracy:", 05, 202, 120, 20)
		Global $Main_Accuracy_lbl = GUICtrlCreateLabel("-----", 125, 202, 25, 20)
		Global $MainAccuracy2_lbl = GUICtrlCreateLabel("%", 150, 203, 20, 20)
		Global $MainAccuracy3_lbl = GUICtrlCreateLabel("Max", 170, 203, 25, 20)
		Global $Main_MAXAccuracy_inp = GUICtrlCreateInput("100", 195, 200, 50, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		GUICtrlCreateUpdown($Main_MAXAccuracy_inp)
		Global $MainAccuracy3_lbl = GUICtrlCreateLabel("%", 245, 203, 20, 20)
		;==> GUI Line 225
		Global $Main_Status_lbl = GUICtrlCreateLabel("Ready", 0, 228, 260, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $SS_SUNKEN))
	#EndRegion Tab1
	#Region Tab2
		$Tab2 = GUICtrlCreateTabItem("Settings")
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		; GUI Cast
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		GUICtrlCreateGroup("Casting", 1, 25, 110, 85)
;		If Not FileExists("Cast.bmp") Then FileInstall("Cast.bmp", "Cast.bmp", 1)
		Global $Mouse_pic = GUICtrlCreateButton("Cast", 10, 63, 40, 40, $BS_BITMAP)
		GUICtrlSetImage($Mouse_pic, "Cast.bmp")
		GUICtrlSetTip($Mouse_pic, "Left click to track mouse, Mouse cords will appear under pointer." & @CRLF & "To check current mouse cords left click then right click.")
		Global $Mouse_lbl = GUICtrlCreateLabel("Cast Button", 10, 45, 80, 20)
		Global $MouseX_lbl = GUICtrlCreateLabel("X:", 55, 65, 10, 20)
		Global $MouseX_inp = GUICtrlCreateInput("", 70, 65, 35, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $MouseY_lbl = GUICtrlCreateLabel("Y:", 55, 87, 10, 20)
		Global $MouseY_inp = GUICtrlCreateInput("", 70, 87, 35, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		; GUI How to cast Bobber
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		GUICtrlCreateGroup("How to Cast", 110, 25, 150, 68)
		Global $Key_rdo = GUICtrlCreateRadio("Key Stroke", 115, 45, 80, 20)
		Global $Mouse_rdo = GUICtrlCreateRadio("Mouse", 198, 45, 55, 20)
		Global $Both_rdo = GUICtrlCreateRadio("Both", 198, 65, 55, 20)
		Global $KeyMod_cbo = GUICtrlCreateCombo("", 115, 65, 58, 20)
		Global $KeyStroke_inp = GUICtrlCreateInput("", 174, 65, 20, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		; GUI Area Adjustments
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		GUICtrlCreateGroup($E_ToDo & " Area", 110, 95, 150, 80)
		Global $F_AreaSet_btn = GUICtrlCreateButton("Show / Set", 140, 115, 80, 20)
		Global $Area_XY_lbl = GUICtrlCreateLabel("   X:    Y:", 118, 135, 80, 15)
		Global $Area_WH_lbl = GUICtrlCreateLabel("Width Height", 179, 135, 80, 15)
		Global $Area_X_inp = GUICtrlCreateInput("", 118, 150, 30, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $Area_Y_inp = GUICtrlCreateInput("", 148, 150, 30, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $Area_Width_inp = GUICtrlCreateInput("", 188, 150, 30, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $Area_Height_inp = GUICtrlCreateInput("", 218, 150, 30, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		; GUI Bobber Adjustments
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		GUICtrlCreateGroup($E_Bobber&" Settings", 1, 110, 110, 138)
		;If Not FileExists("Bobber.bmp") Then FileInstall("Bobber.bmp", "Bobber.bmp", 1)
		Global $Bobber_btn = GUICtrlCreateButton("", 10, 130, 40, 40, $BS_BITMAP)
		GUICtrlSetImage($Bobber_btn, "Bobber.bmp")
		Global $BobberColor_lbl = GUICtrlCreateLabel("", 55, 130, 40, 40)
		Global $BobberHex_inp = GUICtrlCreateInput("0x000000", 10, 173, 85, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $BobberMouseX_inp = GUICtrlCreateInput("X:0", 10, 138, 41, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetState($BobberMouseX_inp, $gui_Hide)
		Global $BobberMouseY_inp = GUICtrlCreateInput("Y:0", 10, 138, 41, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetState($BobberMouseY_inp, $gui_Hide)
		Global $Red_rdo = GUICtrlCreateRadio("Red Feather", 7, 195, 95, 15)
		Global $Blue_rdo = GUICtrlCreateRadio("Blue Feather", 7, 212, 95, 15)
		Global $Brown_rdo = GUICtrlCreateRadio("Brown "&$E_Bobber, 7, 228, 95, 15)
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		; Do Not Disturb
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		GUICtrlCreateGroup("Do Not Disturb", 110, 175, 150, 70)
		Global $DND_cbx = GUICtrlCreateCheckbox("DND Message", 115, 195, 100, 20)
		GUICtrlSetTip($DND_cbx, "Check if you wish to use a Do Not Disturb message.")
		Global $DND_cbo = GUICtrlCreateCombo("...", 115, 215, 140, 20)
		GUICtrlSetTip($DND_cbo, "You can enter your own Do Not Disturb message.")
	#EndRegion Tab2
	#Region Tab3
		$Tab3 = GUICtrlCreateTabItem("Options")
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		; GUI Mode Section
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		GUICtrlCreateGroup("Select " & $E_Mode_, 1, 25, 120, 195);220)
		;If Not FileExists("Mode1.bmp") Then FileInstall("Mode1.bmp", "Mode1.bmp", 1)
		Global $ModeX_inp_1 = GUICtrlCreateInput("", 76, 45, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeX_inp_1, "X cord for " & $E_Mode_1)
		Global $ModeY_inp_1 = GUICtrlCreateInput("", 76, 60, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeY_inp_1, "Y cord for " & $E_Mode_1)
		Global $Mode_cbx_1 = GUICtrlCreateCheckbox("", 03, 45, 10, 10)
		GUICtrlSetTip($Mode_cbx_1, "Check box to equip " & $E_Mode_1)
		Global $Mode_lbl_1 = GUICtrlCreateLabel("Use", 17, 44, 25, 15)
		GUICtrlSetTip($Mode_lbl_1, "Check box to equip " & $E_Mode_1)
		Global $Mode_pic_1 = GUICtrlCreateButton("", 44, 45, 30, 30, $BS_BITMAP);-------
		GUICtrlSetImage($Mode_pic_1, "Mode1.bmp")
		GUICtrlSetTip($Mode_pic_1, $E_Mode_1 & " +25 for 10 min." & @CRLF & "Left click to track mouse, Mouse cords will appear under pointer." & @CRLF & "To check current mouse cords left click then right click.")
		Global $Mode_inp_1 = GUICtrlCreateInput("", 03, 55, 40, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $Mode_inp_ud_1 = GUICtrlCreateUpdown($Mode_inp_1)
		GUICtrlSetTip($Mode_inp_1, "How many " & $E_Mode_1 & "s in inventory?")
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;If Not FileExists("Mode2.bmp") Then FileInstall("Mode2.bmp", "Mode2.bmp", 1)
		Global $ModeX_inp_2 = GUICtrlCreateInput("", 76, 80, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeX_inp_2, "X cord for " & $E_Mode_2)
		Global $ModeY_inp_2 = GUICtrlCreateInput("", 76, 95, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeY_inp_2, "Y cord for " & $E_Mode_2)
		Global $Mode_cbx_2 = GUICtrlCreateCheckbox("", 03, 80, 10, 10)
		GUICtrlSetTip($Mode_cbx_2, "Check box to equip " & $E_Mode_2)
		Global $Mode_lbl_2 = GUICtrlCreateLabel("Use", 17, 79, 25, 15)
		GUICtrlSetTip($Mode_lbl_2, "Check box to equip " & $E_Mode_2)
		Global $Mode_pic_2 = GUICtrlCreateButton("", 44, 80, 30, 30, $BS_BITMAP);-------
		GUICtrlSetImage($Mode_pic_2, "Mode2.bmp")
		GUICtrlSetTip($Mode_pic_2, $E_Mode_2 & " +50 for 10 min." & @CRLF & "Left click to track mouse, Mouse cords will appear under pointer." & @CRLF & "To check current mouse cords left click then right click.")
		Global $Mode_inp_2 = GUICtrlCreateInput("", 03, 90, 40, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $Mode_inp_ud_2 = GUICtrlCreateUpdown($Mode_inp_2)
		GUICtrlSetTip($Mode_inp_2, "How many " & $E_Mode_2 & "s in inventory?")
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;If Not FileExists("Mode3.bmp") Then FileInstall("Mode3.bmp", "Mode3.bmp", 1)
		Global $ModeX_inp_3 = GUICtrlCreateInput("", 76, 115, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeX_inp_3, "X cord for " & $E_Mode_3)
		Global $ModeY_inp_3 = GUICtrlCreateInput("", 76, 130, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeY_inp_3, "Y cord for " & $E_Mode_3)
		Global $Mode_cbx_3 = GUICtrlCreateCheckbox("", 03, 115, 10, 10)
		GUICtrlSetTip($Mode_cbx_3, "Check box to equip " & $E_Mode_3)
		Global $Mode_lbl_3 = GUICtrlCreateLabel("Use", 17, 114, 25, 15)
		GUICtrlSetTip($Mode_lbl_3, "Check box to equip " & $E_Mode_3)
		Global $Mode_pic_3 = GUICtrlCreateButton("", 44, 115, 30, 30, $BS_BITMAP);-------
		GUICtrlSetImage($Mode_pic_3, "Mode3.bmp")
		GUICtrlSetTip($Mode_pic_3, $E_Mode_3 & " +75 for 10 min." & @CRLF & "Left click to track mouse, Mouse cords will appear under pointer." & @CRLF & "To check current mouse cords left click then right click.")
		Global $Mode_inp_3 = GUICtrlCreateInput("", 03, 125, 40, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $Mode_inp_ud_3 = GUICtrlCreateUpdown($Mode_inp_3)
		GUICtrlSetTip($Mode_inp_3, "How many " & $E_Mode_3 & "s in inventory?")
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	;	If Not FileExists("Mode2.bmp") Then FileInstall("Mode2.bmp", "Mode2.bmp", 1)
		Global $ModeX_inp_4 = GUICtrlCreateInput("", 76, 150, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeX_inp_4, "X cord for " & $E_Mode_4)
		Global $ModeY_inp_4 = GUICtrlCreateInput("", 76, 165, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeY_inp_4, "Y cord for " & $E_Mode_4)
		Global $Mode_cbx_4 = GUICtrlCreateCheckbox("", 03, 150, 10, 10)
		GUICtrlSetTip($Mode_cbx_4, "Check box to equip " & $E_Mode_4)
		Global $Mode_lbl_4 = GUICtrlCreateLabel("Use", 17, 149, 25, 15)
		GUICtrlSetTip($Mode_lbl_4, "Check box to equip " & $E_Mode_2)
		Global $Mode_pic_4 = GUICtrlCreateButton("", 44, 150, 30, 30, $BS_BITMAP);-------
		GUICtrlSetImage($Mode_pic_4, "Mode2.bmp")
		GUICtrlSetTip($Mode_pic_4, $E_Mode_4 & " +75 for 10 min." & @CRLF & "Left click to track mouse, Mouse cords will appear under pointer." & @CRLF & "To check current mouse cords left click then right click.")
		Global $Mode_inp_4 = GUICtrlCreateInput("", 03, 160, 40, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $Mode_inp_ud_4 = GUICtrlCreateUpdown($Mode_inp_4)
		GUICtrlSetTip($Mode_inp_4, "How many " & $E_Mode_4 & "s in inventory?")
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;If Not FileExists("Mode5.bmp") Then FileInstall("Mode5.bmp", "Mode5.bmp", 1)
		Global $ModeX_inp_5 = GUICtrlCreateInput("", 76, 185, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeX_inp_5, "X cord for " & $E_Mode_5)
		Global $ModeY_inp_5 = GUICtrlCreateInput("", 76, 200, 40, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetTip($ModeY_inp_5, "Y cord for " & $E_Mode_5)
		Global $Mode_cbx_5 = GUICtrlCreateCheckbox("", 03, 185, 10, 10)
		GUICtrlSetTip($Mode_cbx_5, "Check box to equip " & $E_Mode_5)
		Global $Mode_lbl_5 = GUICtrlCreateLabel("Use", 17, 184, 25, 15)
		GUICtrlSetTip($Mode_lbl_5, "Check box to equip " & $E_Mode_5)
		Global $Mode_pic_5 = GUICtrlCreateButton("", 44, 185, 30, 30, $BS_BITMAP);-------
		GUICtrlSetImage($Mode_pic_5, "Mode5.bmp")
		GUICtrlSetTip($Mode_pic_5, $E_Mode_5 & " +100 for 10 min." & @CRLF & "Left click to track mouse, Mouse cords will appear under pointer." & @CRLF & "To check current mouse cords left click then right click.")
		Global $Mode_inp_5 = GUICtrlCreateInput("", 03, 195, 40, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $Mode_inp_ud_5 = GUICtrlCreateUpdown($Mode_inp_5)
		GUICtrlSetTip($Mode_inp_5, "How many " & $E_Mode_5 & "s in inventory?")
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		Global $ModeSwitch_btn = GUICtrlCreateButton("Change Cast Order", 03, 223, 113, 20)
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		; GUI Bobber pic
		;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		GUICtrlCreateGroup("Dead Check", 120, 25, 140, 80)
		Global $Life_cbx = GUICtrlCreateCheckbox("Enable Dead Check", 125, 40, 130, 17)
		Global $LifeColor_btn = GUICtrlCreateButton("", 125, 58, 43, 38)
		Global $LifeHex_inp = GUICtrlCreateInput("0x000000", 172, 58, 82, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $LifeMouseX_inp = GUICtrlCreateInput("X:0", 172, 78, 41, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $LifeMouseY_inp = GUICtrlCreateInput("Y:0", 212, 78, 41, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlCreateGroup("Auto Reply", 120, 105, 140, 142)
		Global $AutoReply_cbx = GUICtrlCreateCheckbox("Enable Auto Reply", 125, 120, 130, 15)
		Global $AutoReplyColor_btn = GUICtrlCreateButton("", 125, 138, 43, 17)
		Global $AutoReplyHex_inp = GUICtrlCreateInput("0x000000", 172, 138, 82, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL))
		Global $AutoReplyMouseX_inp = GUICtrlCreateInput("X:0", 172, 138, 41, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetState($AutoReplyMouseX_inp, $gui_Hide)
		Global $AutoReplyMouseY_inp = GUICtrlCreateInput("Y:0", 212, 138, 41, 17, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		GUICtrlSetState($AutoReplyMouseY_inp, $gui_Hide)
		Global $AutoReplySet_btn = GUICtrlCreateButton("Show / Set Area", 126, 159, 128, 20)
		Global $AutoReply_X_inp = GUICtrlCreateInput("", 124, 183, 33, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $AutoReply_Y_inp = GUICtrlCreateInput("", 157, 183, 33, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $AutoReply_Width_inp = GUICtrlCreateInput("", 192, 183, 33, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $AutoReply_Height_inp = GUICtrlCreateInput("", 225, 183, 33, 15, BitOR($ES_CENTER, $ES_AUTOHSCROLL, $ES_READONLY))
		Global $AutoReply_cbo = GUICtrlCreateCombo("", 125, 200, 130, 20)
		Global $AutoReplyAdd_btn = GUICtrlCreateButton("Add", 125, 223, 45, 20)
		Global $AutoReplyRemove_btn = GUICtrlCreateButton("Remove", 190, 223, 65, 20)
	#EndRegion Tab3
	GUISetState(@SW_SHOW, $MainGUI)
EndFunc   ;==>BuildGUI
#EndRegion BuildGUI
#Region Check Settings
Func CheckSettings() ;==> CheckSettings
	GUICtrlSetData($Main_Status_lbl, "Checking Setting ("&$IniFile&")")
	#Region Load Main
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; Load Saved Main
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	If IniRead($IniFile, "Main", "Untill", "4") = 1 Then
		GUICtrlSetState($Main_Untill_cbx, $GUI_CHECKED)
	EndIf
	GUICtrlSetData($Main_Untill_Time, IniRead($IniFile, "Main", "Untill_Time", ""))
	GUICtrlSetData($Main_Start_lbl, IniRead($IniFile, "Main", "Start", "---:---:--- xx"))
	GUICtrlSetData($Main_Timer_lbl, IniRead($IniFile, "Main", "Timer", "---"))
	GUICtrlSetData($Main_MAXTimer_inp, IniRead($IniFile, "Main", "MAXTimer", "25"))
	GUICtrlSetData($Main_Shades_inp, IniRead($IniFile, "Main", "Shades", "0"))
	GUICtrlSetData($Main_MaxShades_inp, IniRead($IniFile, "Main", "MaxShades", "255"))
	GUICtrlSetData($Main_Slider_sld, IniRead($IniFile, "Main", "Slider", "0"))
	GUICtrlSetData($Main_Cast_lbl, IniRead($IniFile, "Main", "Cast", "-----"))
	GUICtrlSetData($Main_Bobber_lbl, IniRead($IniFile, "Main", "Bobber", "-----"))
	GUICtrlSetData($Main_Caught_lbl, IniRead($IniFile, "Main", "Caught", "-----"))
	GUICtrlSetData($Main_Accuracy_lbl, IniRead($IniFile, "Main", "Accuracy", "----"))
	GUICtrlSetData($Main_MAXAccuracy_inp, IniRead($IniFile, "Main", "MAXAccuracy", "100"))
	#EndRegion
	#Region Load Settings
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; Load Saved Settings
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	GUICtrlSetData($MouseX_inp, IniRead($IniFile, "Settings", "MouseX", ""))
	GUICtrlSetData($MouseY_inp, IniRead($IniFile, "Settings", "MouseY", ""))
	If IniRead($IniFile, "Settings", "Both", "1") = 1 Then
		GUICtrlSetState($Both_rdo, $GUI_CHECKED)
	ElseIf IniRead($IniFile, "Settings", "Key", "4") = 1 Then
		GUICtrlSetState($Key_rdo, $GUI_CHECKED)
	ElseIf IniRead($IniFile, "Settings", "Mouse", "4") = 1 Then
		GUICtrlSetState($Mouse_rdo, $GUI_CHECKED)
	EndIf
	GUICtrlSetData($KeyMod_cbo, " |Alt|Ctrl|Shift|Tab", IniRead($IniFile, "Settings", "KeyMod", ""))
	GUICtrlSetData($KeyStroke_inp, IniRead($IniFile, "Settings", "KeyStroke", "1"))
	GUICtrlSetData($Area_X_inp, IniRead($IniFile, "Settings", "Area_X", ""))
	GUICtrlSetData($Area_Y_inp, IniRead($IniFile, "Settings", "Area_Y", ""))
	GUICtrlSetData($Area_Height_inp, IniRead($IniFile, "Settings", "Area_Height", ""))
	GUICtrlSetData($Area_Width_inp, IniRead($IniFile, "Settings", "Area_Width", ""))
	GUICtrlSetData($BobberHex_inp, IniRead($IniFile, "Settings", "BobberHex", "0x8B1F12"))
	GUICtrlSetBkColor($BobberColor_lbl,GUICtrlRead($BobberHex_inp))
	If IniRead($IniFile, "Settings", "Red", "1") = 1 Then
		GUICtrlSetState($Red_rdo, $GUI_CHECKED)
	ElseIf IniRead($IniFile, "Settings", "Blue", "4") = 1 Then
		GUICtrlSetState($Blue_rdo, $GUI_CHECKED)
	ElseIf IniRead($IniFile, "Settings", "Brown", "4") = 1 Then
		GUICtrlSetState($Brown_rdo, $GUI_CHECKED)
	EndIf
	If IniRead($IniFile, "Options", "DND", "4") = 1 Then GUICtrlSetData($DND_cbx, $GUI_CHECKED)
	$DND_List = IniReadSection($IniFile, "DND Messages")
	For $i = 1 To $DND_List[0][0]
		GUICtrlSetData($DND_cbo, $DND_List[$i][1])
		;GUICtrlSetData($DND_cbo, "DND TEST")
	Next
	GUICtrlSetData($DND_cbo, IniRead($IniFile, "Main", "Message", "..."))
	#EndRegion
	#Region Load Options
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; Load Saved Options
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	IniWrite($IniFile, "Options", "Timer", "0");	Timer=0
	IniWrite($IniFile, "Options", "Start", "0");	Start=0
	GUICtrlSetData($Mode_inp_1, IniRead($IniFile, "Options", "Mode1", "0"))
	GUICtrlSetData($Mode_inp_2, IniRead($IniFile, "Options", "Mode2", "0"))
	GUICtrlSetData($Mode_inp_3, IniRead($IniFile, "Options", "Mode3", "0"))
	GUICtrlSetData($Mode_inp_4, IniRead($IniFile, "Options", "Mode4", "0"))
	GUICtrlSetData($Mode_inp_5, IniRead($IniFile, "Options", "Mode5", "0"))
	GUICtrlSetData($ModeX_inp_1, IniRead($IniFile, "Options", "ModeX1", ""))
	GUICtrlSetData($ModeY_inp_1, IniRead($IniFile, "Options", "ModeY1", ""))
	GUICtrlSetData($ModeX_inp_2, IniRead($IniFile, "Options", "ModeX2", ""))
	GUICtrlSetData($ModeY_inp_2, IniRead($IniFile, "Options", "ModeY2", ""))
	GUICtrlSetData($ModeX_inp_3, IniRead($IniFile, "Options", "ModeX3", ""))
	GUICtrlSetData($ModeY_inp_3, IniRead($IniFile, "Options", "ModeY3", ""))
	GUICtrlSetData($ModeX_inp_4, IniRead($IniFile, "Options", "ModeX4", ""))
	GUICtrlSetData($ModeY_inp_4, IniRead($IniFile, "Options", "ModeY4", ""))
	GUICtrlSetData($ModeX_inp_5, IniRead($IniFile, "Options", "ModeX5", ""))
	GUICtrlSetData($ModeY_inp_5, IniRead($IniFile, "Options", "ModeY5", ""))
	If IniRead($IniFile, "Options", "Mode1", "4") = 1 Then GUICtrlSetState($Mode_cbx_1, $GUI_CHECKED)
	If IniRead($IniFile, "Options", "Mode2", "4") = 1 Then GUICtrlSetState($Mode_cbx_2, $GUI_CHECKED)
	If IniRead($IniFile, "Options", "Mode3", "4") = 1 Then GUICtrlSetState($Mode_cbx_3, $GUI_CHECKED)
	If IniRead($IniFile, "Options", "Mode4", "4") = 1 Then GUICtrlSetState($Mode_cbx_4, $GUI_CHECKED)
	If IniRead($IniFile, "Options", "Mode5", "4") = 1 Then GUICtrlSetState($Mode_cbx_5, $GUI_CHECKED)
	If IniRead($IniFile, "Options", "Dead", "1") = 1 Then GUICtrlSetState($Life_cbx, $GUI_CHECKED)
	GUICtrlSetData($LifeHex_inp, IniRead($IniFile, "Options", "LifeHex", "0x00B000"))
	GUICtrlSetBkColor($LifeColor_btn,GUICtrlRead($LifeHex_inp))
	GUICtrlSetData($LifeMouseX_inp, IniRead($IniFile, "Options", "LifeMouseX", ""))
	GUICtrlSetData($LifeMouseY_inp, IniRead($IniFile, "Options", "LifeMouseY", ""))
	If IniRead($IniFile, "Options", "AutoReply", "1") = 1 Then GUICtrlSetState($AutoReply_cbx, $GUI_CHECKED)
	GUICtrlSetData($AutoReplyHex_inp, IniRead($IniFile, "Options", "AutoReplyHex", "0xDF72DF"))
	GUICtrlSetBkColor($AutoReplyColor_btn,GUICtrlRead($AutoReplyHex_inp))
	GUICtrlSetData($AutoReplyMouseX_inp, IniRead($IniFile, "Options", "AutoReplyMouseX", ""))
	GUICtrlSetData($AutoReplyMouseY_inp, IniRead($IniFile, "Options", "AutoReplyMouseY", ""))
	GUICtrlSetData($AutoReply_X_inp, IniRead($IniFile, "Options", "AutoReply_X", ""))
	GUICtrlSetData($AutoReply_Y_inp, IniRead($IniFile, "Options", "AutoReply_Y", ""))
	GUICtrlSetData($AutoReply_Height_inp, IniRead($IniFile, "Options", "AutoReply_Height", ""))
	GUICtrlSetData($AutoReply_Width_inp, IniRead($IniFile, "Options", "AutoReply_Width", ""))
	$AutoReply_List = IniReadSection($IniFile, "Reply Messages")
	For $i = 1 To $AutoReply_List[0][0]
		GUICtrlSetData($AutoReply_cbo, $AutoReply_List[$i][1])
	;	GUICtrlSetData($AutoReply_cbo, "Auto Reply TEST")
	Next
	GUICtrlSetData($AutoReply_cbo, IniRead($IniFile, "Options", "Message", "..."))
	#EndRegion
	GUICtrlSetData($Main_Status_lbl, "All Saved Data Loaded")
EndFunc ;==> CheckSettings
#EndRegion Check Settings
#Region Main While
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;The Main while (Loop)
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func Main_While()
	HotKeySet("+z", "Stop")
	While 1
		$Msg = GUIGetMsg()
		Select
			Case $Msg = $Start_btn
				Start()
			Case $Msg = $Stop_btn
				Stop()
			Case $Msg = $GUI_EVENT_CLOSE
				MsgBox(0, "Exit...", "Thank you for using!"&@CRLF&"We love you Nigma",1)
				GUIDelete($MainGUI)
				Exit
			Case $Msg = $About_btn
				MsgBox(0, "..•' All about it! '•..", "Date: 5/11/07  |  Updated: 03/30/08" & @CRLF & "Creator: Mike Patten aka Nigma" & @CRLF & "Beta Testers: Co, Ricky, Josh, Ryan and |-|31PL3SS" & @CRLF & @CRLF & "To report bugs or suggestions Email: Admin@Net-Tap.com")
			Case $Msg = $Help_btn
				MsgBox(0, "HELP", "Please read the Readme.txt file.")
			Case $Msg = $Mouse_pic
				$MouseX = $MouseX_inp
				$MouseY = $MouseY_inp
				Click($MouseX, $MouseY)
			Case $Msg = $Mode_pic_1
				$MouseX = $ModeX_inp_1
				$MouseY = $ModeY_inp_1
				Click($MouseX, $MouseY)
			Case $Msg = $Mode_pic_2
				$MouseX = $ModeX_inp_2
				$MouseY = $ModeY_inp_2
				Click($MouseX, $MouseY)
			Case $Msg = $Mode_pic_3
				$MouseX = $ModeX_inp_3
				$MouseY = $ModeY_inp_3
				Click($MouseX, $MouseY)
			Case $Msg = $Mode_pic_4
				$MouseX = $ModeX_inp_4
				$MouseY = $ModeY_inp_4
				Click($MouseX, $MouseY)
			Case $Msg = $Mode_pic_5
				$MouseX = $ModeX_inp_5
				$MouseY = $ModeY_inp_5
				Click($MouseX, $MouseY)
			Case $Msg = $Bobber_btn
				$Color_lbl = $BobberColor_lbl
				$ColorHex = $BobberHex_inp
				$ColorMouseX = $BobberMouseX_inp
				$ColorMouseY = $BobberMouseY_inp
				SetColor($Color_lbl, $ColorHex, $ColorMouseX, $ColorMouseY)
			Case $Msg = $LifeColor_btn
				$Color_lbl = $LifeColor_btn
				$ColorHex = $LifeHex_inp
				$ColorMouseX = $LifeMouseX_inp
				$ColorMouseY = $LifeMouseY_inp
				SetColor($Color_lbl, $ColorHex, $ColorMouseX, $ColorMouseY)
			Case $Msg = $AutoReplyColor_btn
				$Color_lbl = $AutoReplyColor_btn
				$ColorHex = $AutoReplyHex_inp
				$ColorMouseX = $AutoReplyMouseX_inp
				$ColorMouseY = $AutoReplyMouseY_inp
				SetColor($Color_lbl, $ColorHex, $ColorMouseX, $ColorMouseY)
			Case $Msg = $ModeSwitch_btn
				CastOrder()
			Case $Msg = $AutoReplySet_btn
				$What = "Move and Adjust this window to cover you Chat window."
				$X = $AutoReply_X_inp
				$Y = $AutoReply_Y_inp
				$Height = $AutoReply_Height_inp
				$Width = $AutoReply_Width_inp
				SetArea($What, $X, $Y, $Height, $Width)
			Case $Msg = $F_AreaSet_btn
				$What = "This window reprsents your "&$E_ToDo2&" Area."
				$X = $Area_X_inp
				$Y = $Area_Y_inp
				$Height = $Area_Height_inp
				$Width = $Area_Width_inp
				SetArea($What, $X, $Y, $Height, $Width)
		EndSelect
		GUICtrlSetData($CurrentTime, $DTS_TIMEFORMAT)
		GUICtrlSetData($Main_Shades_inp,GUICtrlRead($Main_Slider_sld))
		Window()
	WEnd
EndFunc   ;==>Main_While
Exit
#EndRegion Main While
#Region Start, Save, Bot, Stop
Func Start()
	GUICtrlSetState($Stop_btn, $gui_Show)
	GUICtrlSetState($Start_btn, $gui_Disable)
	GUICtrlSetState($About_btn, $gui_Disable)
	GUICtrlSetState($Help_btn, $gui_Disable)
	GUICtrlSetData($CurrentTime, $DTS_TIMEFORMAT)
	GUICtrlSetData($Main_Start_lbl, GUICtrlRead($CurrentTime))
	GUICtrlSetData($Main_Status_lbl, "You are about to start "&$E_ToDo)
	If GUICtrlRead($WinMode_cbx) = 1 Then Fullscreen()
	Save()
	Bot()
EndFunc
Func Save()
	GUICtrlSetData($Main_Status_lbl, "Saving all your settings")
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; Save Main
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	IniWrite($IniFile, "Main", "Untill", GUICtrlRead($Main_Untill_cbx))
	IniWrite($IniFile, "Main", "Untill_Time", GUICtrlRead($Main_Untill_Time))
	IniWrite($IniFile, "Main", "MAXTimer", GUICtrlRead($Main_MAXTimer_inp))
	IniWrite($IniFile, "Main", "MaxShades", GUICtrlRead($Main_MaxShades_inp))
	IniWrite($IniFile, "Main", "Cast", GUICtrlRead($Main_Cast_lbl))
	IniWrite($IniFile, "Main", "Bobber", GUICtrlRead($Main_Bobber_lbl))
	IniWrite($IniFile, "Main", "Caught", GUICtrlRead($Main_Caught_lbl))
	IniWrite($IniFile, "Main", "Accuracy", GUICtrlRead($Main_Accuracy_lbl))
	IniWrite($IniFile, "Main", "MAXAccuracy", GUICtrlRead($Main_MAXAccuracy_inp))
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	; Save Settings
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	IniWrite($IniFile,"Settings", "MouseX",GUICtrlRead($MouseX_inp))
	IniWrite($IniFile,"Settings", "MouseY",GUICtrlRead($MouseY_inp))
	Select
		Case GUICtrlRead($Key_rdo) = 1
			IniWrite($IniFile,"Settings", "Both", "4")
			IniWrite($IniFile,"Settings", "Key", "1");GUICtrlRead($Key_rdo))
			IniWrite($IniFile,"Settings", "Mouse", "4")
		Case GUICtrlRead($Mouse_rdo) = 1
			IniWrite($IniFile,"Settings", "Both","4")
			IniWrite($IniFile,"Settings", "Key","4")
			IniWrite($IniFile,"Settings", "Mouse","1");GUICtrlRead($Mouse_rdo))
		Case GUICtrlRead($Both_rdo) = 1
			IniWrite($IniFile,"Settings", "Both","1");GUICtrlRead($Both_rdo))
			IniWrite($IniFile,"Settings", "Key","4")
			IniWrite($IniFile,"Settings", "Mouse","4")
	EndSelect
	IniWrite($IniFile,"Settings", "KeyMod",GUICtrlRead($KeyMod_cbo))
	IniWrite($IniFile,"Settings", "KeyStroke",GUICtrlRead($KeyStroke_inp))
	IniWrite($IniFile,"Settings", "Area_X",GUICtrlRead($Area_X_inp))
	IniWrite($IniFile,"Settings", "Area_Y",GUICtrlRead($Area_Y_inp))
	IniWrite($IniFile,"Settings", "Area_Height",GUICtrlRead($Area_Height_inp))
	IniWrite($IniFile,"Settings", "Area_Width",GUICtrlRead($Area_Width_inp))
	IniWrite($IniFile,"Settings", "BobberHex",GUICtrlRead($BobberHex_inp))
	Select
		Case GUICtrlRead($Red_rdo) = 1
			IniWrite($IniFile,"Settings", "Red", "1")
			IniWrite($IniFile,"Settings", "Blue", "4")
			IniWrite($IniFile,"Settings", "Brown", "4")
		Case GUICtrlRead($Blue_rdo) = 1
			IniWrite($IniFile,"Settings", "Red", "4")
			IniWrite($IniFile,"Settings", "Blue", "1")
			IniWrite($IniFile,"Settings", "Brown", "4")
		Case GUICtrlRead($Brown_rdo) = 1
			IniWrite($IniFile,"Settings", "Red", "4")
			IniWrite($IniFile,"Settings", "Blue", "4")
			IniWrite($IniFile,"Settings", "Brown", "1")
	EndSelect
	IniWrite($IniFile, "Options", "DND", GUICtrlRead($DND_cbx))
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	;Save Optioons
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	IniWrite($IniFile,"Options", "M1",GUICtrlRead($Mode_cbx_1))
	IniWrite($IniFile,"Options", "M2",GUICtrlRead($Mode_cbx_2))
	IniWrite($IniFile,"Options", "M3",GUICtrlRead($Mode_cbx_3))
	IniWrite($IniFile,"Options", "M4",GUICtrlRead($Mode_cbx_4))
	IniWrite($IniFile,"Options", "M5",GUICtrlRead($Mode_cbx_5))
	IniWrite($IniFile,"Options", "Mode1",GUICtrlRead($Mode_inp_1))
	IniWrite($IniFile,"Options", "Mode2",GUICtrlRead($Mode_inp_2))
	IniWrite($IniFile,"Options", "Mode3",GUICtrlRead($Mode_inp_3))
	IniWrite($IniFile,"Options", "Mode4",GUICtrlRead($Mode_inp_4))
	IniWrite($IniFile,"Options", "Mode5",GUICtrlRead($Mode_inp_5))
	IniWrite($IniFile,"Options", "ModeX1",GUICtrlRead($ModeX_inp_1))
	IniWrite($IniFile,"Options", "ModeY1",GUICtrlRead($ModeY_inp_1))
	IniWrite($IniFile,"Options", "ModeX2",GUICtrlRead($ModeX_inp_2))
	IniWrite($IniFile,"Options", "ModeY2",GUICtrlRead($ModeY_inp_2))
	IniWrite($IniFile,"Options", "ModeX3",GUICtrlRead($ModeX_inp_3))
	IniWrite($IniFile,"Options", "ModeY3",GUICtrlRead($ModeY_inp_3))
	IniWrite($IniFile,"Options", "ModeX4",GUICtrlRead($ModeX_inp_4))
	IniWrite($IniFile,"Options", "ModeY4",GUICtrlRead($ModeY_inp_4))
	IniWrite($IniFile,"Options", "ModeX5",GUICtrlRead($ModeX_inp_5))
	IniWrite($IniFile,"Options", "ModeY5",GUICtrlRead($ModeY_inp_5))
	IniWrite($IniFile,"Options", "WinMode",GUICtrlRead($WinMode_cbx))
	IniWrite($IniFile,"Options", "Life",GUICtrlRead($Life_cbx))
	IniWrite($IniFile,"Options", "LifeColor",GUICtrlRead($LifeColor_btn))
	IniWrite($IniFile,"Options", "LifeHex",GUICtrlRead($LifeHex_inp))
	IniWrite($IniFile,"Options", "LifeMouseX",GUICtrlRead($LifeMouseX_inp))
	IniWrite($IniFile,"Options", "LifeMouseY",GUICtrlRead($LifeMouseY_inp))
	IniWrite($IniFile,"Options", "AutoReply",GUICtrlRead($AutoReply_cbx))
	IniWrite($IniFile,"Options", "AutoReplyColor",GUICtrlRead($AutoReplyColor_btn))
	IniWrite($IniFile,"Options", "AutoReplyHex",GUICtrlRead($AutoReplyHex_inp))
	IniWrite($IniFile,"Options", "AutoReplyMouseX",GUICtrlRead($AutoReplyMouseX_inp))
	IniWrite($IniFile,"Options", "AutoReplyMouseY",GUICtrlRead($AutoReplyMouseY_inp))
	IniWrite($IniFile,"Options", "AutoReplySet",GUICtrlRead($AutoReplySet_btn))
	IniWrite($IniFile,"Options", "AutoReply_X",GUICtrlRead($AutoReply_X_inp))
	IniWrite($IniFile,"Options", "AutoReply_Y",GUICtrlRead($AutoReply_Y_inp))
	IniWrite($IniFile,"Options", "AutoReply_Width",GUICtrlRead($AutoReply_Width_inp))
	IniWrite($IniFile,"Options", "AutoReply_Height",GUICtrlRead($AutoReply_Height_inp))
	IniWrite($IniFile,"Options", "AutoReplyAdd",GUICtrlRead($AutoReplyAdd_btn))
	IniWrite($IniFile,"Options", "AutoReplyRemove",GUICtrlRead($AutoReplyRemove_btn))
EndFunc
Func Bot()
	$Loop = 0
	$Show = 0
	Do
		Do
			If GUIGetMsg() = $Stop_btn Then Stop()
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			If $Show = 1 Then GUICtrlSetData($Main_Accuracy_lbl, ($Caught/$Cast)*100)
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			If GUICtrlRead($AutoReply_cbx) = 1 Then ChatCheck()
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			If GUICtrlRead($Life_cbx) = 1 Then DeadCheck()
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			If GUICtrlRead($Main_Untill_cbx) = 1 Then StopTimer()
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			If GUICtrlRead($DND_cbx) = 1 Then DND()
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			ModeCheck()
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			RandomAction()
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;===> Cast
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			#Region Cast
			Sleep(Random(150,500))
			GUICtrlSetData($Main_Status_lbl, "You will now start "&$E_ToDo)
			If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Casting...","You will now start "&$E_ToDo, 3);Windowed Mode Only
			If GUIGetMsg() = $Stop_btn Then Stop()
			Sleep(Random(750,1500))
			$Trys = 0
			Select
				Case BitAND(GUICtrlRead($Key_rdo), $GUI_CHECKED) = $GUI_CHECKED
					GUICtrlSetData($Main_Status_lbl, "You will cast useing Keystroke ")
					If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Casting...","You will cast useing Keystroke", 3);Windowed Mode Only
					While 1
						If GUIGetMsg() = $Stop_btn Then Stop()
						If WinExists($E_Title) = 1 and WinActive($E_Title) = 1 Then
							If GUICtrlRead($KeyMod_cbo) = "" Then
								Send(GUICtrlRead($KeyStroke_inp))
								ExitLoop
							Else
								Send("{"&GUICtrlRead($KeyMod_cbo)&"}"&"+"&GUICtrlRead($KeyStroke_inp))
								ExitLoop
							EndIf
						ElseIf WinExists($E_Title) = 0 and ProcessExists($E_Title2&".exe") Then
							WinActivate($E_Title)
							If GUICtrlRead($KeyMod_cbo) = "" Then
								Send(GUICtrlRead($KeyStroke_inp))
								ExitLoop
							Else
								Send("{"&GUICtrlRead($KeyMod_cbo)&"}"&"+"&GUICtrlRead($KeyStroke_inp))
								ExitLoop
							EndIf
						EndIf
						$Trys = $Trys + 1
						Sleep(Random(750,1500))
					WEnd
				Case BitAND(GUICtrlRead($Mouse_rdo), $GUI_CHECKED) = $GUI_CHECKED
					GUICtrlSetData($Main_Status_lbl, "You will cast useing Mouse Click")
					If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Casting...","You will cast useing Mouse Click", 3);Windowed Mode Only
					While 1
						If GUIGetMsg() = $Stop_btn Then Stop()
						If WinExists($E_Title) = 1 Then
							;$Mouse = MouseGetPos()
							;ToolTip("WinExists and NOT WinActive", $Mouse[0]+10,$Mouse[1]+5)
							WinActivate($E_Title)
							Sleep(Random(50,100))
							MouseClick("Left",GUICtrlRead($MouseX_inp), GUICtrlRead($MouseY_inp), 1, random(5,50))
							ExitLoop
						ElseIf WinExists($E_Title) = 0 and ProcessExists($E_Title2&".exe") Then
							$Mouse = MouseGetPos()
							ToolTip("NOT WinExists and NOT WinActive", $Mouse[0]+10,$Mouse[1]+5)
							WinActivate($E_Title)
							MouseClick("Left",GUICtrlRead($MouseX_inp), GUICtrlRead($MouseY_inp), 1, random(5,50))
							ExitLoop
						ElseIf $Trys = 3 Then
							MsgBox(0,"Error while Mouse Casting","Error while Casting"&@CRLF&"Unable to Activate "&$E_Title&" window.",3)
							ExitLoop
							Exit
						EndIf
						$Trys = $Trys + 1
						Sleep(Random(750,1500))
					WEnd
				Case BitAND(GUICtrlRead($Both_rdo), $GUI_CHECKED) = $GUI_CHECKED
					GUICtrlSetData($Main_Status_lbl, "You will cast useing Both Mouse and Keystroke")
					If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Casting...","You will cast useing Both Mouse and Keystroke", 3);Windowed Mode Only
					$RanCast = round(Random(1,2),0)
					IF $RanCast = 1 Then
						GUICtrlSetData($Main_Status_lbl, "You will cast useing Keystroke (Both)")
						If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Casting...","You will cast useing Keystroke (Both)", 3);Windowed Mode Only
						While 1
							If GUIGetMsg() = $Stop_btn Then Stop()
							If WinExists($E_Title) = 1 Then
								WinActivate($E_Title)
								If GUICtrlRead($KeyMod_cbo) = "" Then
									Send(GUICtrlRead($KeyStroke_inp))
									ExitLoop
								Else
									Send("{"&GUICtrlRead($KeyMod_cbo)&"}"&"+"&GUICtrlRead($KeyStroke_inp))
									ExitLoop
								EndIf
							ElseIf $Trys = 3 Then
								MsgBox(0,"Error while Casting","Error while Casting"&@CRLF&"Unable to Activate "&$E_Title&" window.",3)
								ExitLoop
								Exit
							EndIf
							$Trys = $Trys + 1
							MouseClick("Left",GUICtrlRead($MouseX_inp), GUICtrlRead($MouseY_inp), 1, random(5,50))
							Sleep(Random(750,1500))
						WEnd
					Else
						GUICtrlSetData($Main_Status_lbl, "You will cast useing Mouse Click (Both)")
						If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Casting...","You will cast useing Mouse Click (Both)", 3);Windowed Mode Only
						While 1
							If GUIGetMsg() = $Stop_btn Then Stop()
							If WinExists($E_Title) = 1 Then
								MsgBox(0,"WinExists", WinExists($E_Title))
								If WinActive($E_Title) = 1 Then MouseClick("Left",GUICtrlRead($MouseX_inp), GUICtrlRead($MouseY_inp), 1, random(5,50))
								If WinActive($E_Title) = 0 Then
									WinActivate($E_Title)
									MouseClick("Left",GUICtrlRead($MouseX_inp), GUICtrlRead($MouseY_inp), 1, random(5,50))
								EndIf
								ExitLoop
							ElseIf WinExists($E_Title) = 0 and ProcessExists($E_Title2&".exe") Then
								WinActivate($E_Title)
								MouseClick("Left",GUICtrlRead($MouseX_inp), GUICtrlRead($MouseY_inp), 1, random(5,50))
								ExitLoop
							ElseIf $Trys = 3 Then
								MsgBox(0,"Error while Mouse Casting","Error while Casting"&@CRLF&"Unable to Activate "&$E_Title&" window.",3)
								ExitLoop
								Exit
							EndIf
						$Trys = $Trys + 1
						Sleep(Random(750,1500))
						WEnd
					EndIf
			EndSelect
			$Cast = $Cast + 1
			$Show = 1
			GUICtrlSetData($Main_Cast_lbl, $Cast)
			#EndRegion
			Sleep(Random(1000,2000))
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;===> PixelSearch Start
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			#Region PixelSearch
			Global $Timer = TimerInit()
			$Left = GUICtrlRead($Area_X_inp)
			$Top = GUICtrlRead($Area_Y_inp)
			$Right = GUICtrlRead($Area_X_inp)+GUICtrlRead($Area_Width_inp)
			$Bottom = GUICtrlRead($Area_Y_inp)+GUICtrlRead($Area_Height_inp)
			GUICtrlSetBkColor($Main_Color_lbl, GUICtrlRead($BobberHex_inp))
			GUICtrlSetData($Main_Area_lbl, "Left: "&$Left&" Top: "&$Top&" Right: "&$Right&" Bottom: "&$Bottom)
			GUICtrlSetData($Main_Status_lbl, "Searching for "&$E_Bobber&" ...")
			$Adjust = 0
			Do
				Sleep(Random(10,50))
				If GUIGetMsg() = $Stop_btn Then Stop()
				GUICtrlSetData($Main_Shades_inp, $Adjust)
				GUICtrlSetData($Main_Slider_sld, $Adjust)
				$PixSearch = PixelSearch($Left, $Top, $Right, $Bottom, GUICtrlRead($BobberHex_inp), $Adjust, 2)
				If @error = 1 Then $Adjust = $Adjust + 1
				If $Adjust > GUICtrlRead($Main_MaxShades_inp) Then $Adjust = 0
			Until IsArray($PixSearch) = 1 or CheckTimer(); or $Adjust > GUICtrlRead($Main_MaxShades_inp)
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;===> PixelSearch Move to Bobber (Randomly)
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			If IsArray($PixSearch) = 1 Then
				;_ArrayDisplay($PixSearch)
				$beep = 0
				If GUICtrlRead($Main_cbx) = 1 Then
					GUICtrlSetData($Main_Status_lbl, "*** ALARM IS ACTIVE ***")
					Do
						SoundPlay(@WindowsDir & "\media\tada.wav",1)
						$beep = $beep + 1
						Sleep(Random(500,1000))
					Until $beep = 10
					Stop()
				EndIf
				$Found = $Found + 1
				GUICtrlSetData($Main_Bobber_lbl, $Found)
				GUICtrlSetData($Main_Status_lbl, "Waitting for <'))>< to bit...")
				If GUIGetMsg() = $Stop_btn Then Stop()
				$Ran1 = round(Random(1,5),0)
				$Ran2 = round(Random(5,25),0)
				$Ran3 = round(Random(1,2),0)
				$Ran4 = round(Random(1,2),0)
				$Ran5 = round(Random(10,65),0)
				For $Ran0=1 to $Ran4
					If GUIGetMsg() = $Stop_btn Then Stop()
					If $Ran4 = 1 Then
						For $Ran0=1 to $Ran1
							If $Ran3 = 1 Then MouseMove($PixSearch[0]+$Ran2, $PixSearch[1]-$Ran2, random(15,50))
							If $Ran3 = 2 Then MouseMove($PixSearch[0]-$Ran2, $PixSearch[1]+$Ran2, random(10,25))
							Sleep(Random(5,50))
						Next
						MouseMove($PixSearch[0], $PixSearch[1], random(10,25))
						Sleep(Random(100,500))
						MouseMove($PixSearch[0]+7, $PixSearch[1], random(10,25))
						Sleep(Random(100,500))
					ElseIf $Ran4 = 2 Then
						For $Ran0=1 to $Ran1
							If $Ran3 = 1 Then MouseMove($PixSearch[0]+$Ran5, $PixSearch[1]-$Ran5, random(15,50))
							If $Ran3 = 2 Then MouseMove($PixSearch[0]-$Ran5, $PixSearch[1]+$Ran5, random(10,25))
							Sleep(Random(5,50))
						Next
					EndIf
				Next
				#cs
				If GUICtrlRead($Main_Splash_rdo) = 1 Then
					If GUICtrlRead($Red_rdo) = 1 Then
						$SLeft = $PixSearch[0] - 45
						$SRight = $PixSearch[0] + 10
						$STop = $PixSearch[1] - 15
						$SBottom = $PixSearch[1] + 25
					ElseIf GUICtrlRead($Blue_rdo) = 1 Then
						$SLeft = $PixSearch[0] - 55
						$SRight = $PixSearch[0] - 0
						$STop = $PixSearch[1] + 0
						$SBottom = $PixSearch[1] + 45
					ElseIf GUICtrlRead($Brown_rdo) = 1 Then
						$SLeft = $PixSearch[0] - 35
						$SRight = $PixSearch[0] - 0
						$STop = $PixSearch[1] + 15
						$SBottom = $PixSearch[1] + 25
					EndIf
				ElseIf GUICtrlRead($Main_Bobber_rdo) = 1 Then
					$SLeft = $PixSearch[0] - 0
					$SRight = $PixSearch[0] + 0
					$STop = $PixSearch[1] - 0
					$SBottom = $PixSearch[1] + 0
					$Adjust = 30
				Else
					MsgBox(0,"ERROR (987)","GUICtrlRead($Main_Splash_rdo) = 1")
					Stop()
				EndIf
				#ce
				$SLeft = $PixSearch[0] - 0
				$SRight = $PixSearch[0] + 0
				$STop = $PixSearch[1] - 0
				$SBottom = $PixSearch[1] + 0
				$Adjust = GUICtrlRead($Main_MaxShades_inp)
			Else
				Bot()
			EndIf
			Sleep(Random(250,550))
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;===> PixelSearch Start
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;If GUICtrlRead($Main_Splash_rdo) = 1 Then
			;	Do
			;		If GUIGetMsg() = $Stop_btn Then Stop()
			;		Sleep(Random(10,50))
			;		$Bobber2Pos = PixelSearch($SLeft, $STop, $SRight, $SBottom, 0xF6F6F6, 20, 1)
					#cs
					MouseMove($SLeft, $STop, 5)
					Sleep(500)
					MouseMove($SRight, $STop, 5)
					Sleep(500)
					MouseMove($SRight, $SBottom, 5)
					Sleep(500)
					MouseMove($SLeft, $SBottom, 5)
					Sleep(500)
					TrayTip("Slash "&$Adjust&" "&GUICtrlRead($BobberHex_inp), IsArray($Bobber2Pos), 5)
					#ce
			;	Until CheckTimer() or IsArray($Bobber2Pos) = 1
			;ElseIf GUICtrlRead($Main_Bobber_rdo) = 1 Then
				Do
					If GUIGetMsg() = $Stop_btn Then Stop()
					Sleep(Random(10,50))
					$Bobber2Pos = PixelSearch($SLeft, $STop, $SRight, $SBottom, GUICtrlRead($BobberHex_inp), $Adjust, 1)
					#cs
					$Mouse = MouseGetPos()
					ToolTip("Bobber "&$Adjust&" "&GUICtrlRead($BobberHex_inp)&" - "&IsArray($Bobber2Pos), $Mouse[0]+10,$Mouse[1]+5)
					MouseMove($SLeft, $STop, 5)
					Sleep(500)
					$Mouse = MouseGetPos()
					ToolTip("Bobber "&$Adjust&" "&GUICtrlRead($BobberHex_inp)&" - "&IsArray($Bobber2Pos), $Mouse[0]+10,$Mouse[1]+5)
					MouseMove($SRight, $STop, 5)
					Sleep(500)
					$Mouse = MouseGetPos()
					ToolTip("Bobber "&$Adjust&" "&GUICtrlRead($BobberHex_inp)&" - "&IsArray($Bobber2Pos), $Mouse[0]+10,$Mouse[1]+5)
					MouseMove($SRight, $SBottom, 5)
					Sleep(500)
					$Mouse = MouseGetPos()
					ToolTip("Bobber "&$Adjust&" "&GUICtrlRead($BobberHex_inp)&" - "&IsArray($Bobber2Pos), $Mouse[0]+10,$Mouse[1]+5)
					MouseMove($SLeft, $SBottom, 5)
					Sleep(500)
					#ce
					If @error = 1 Then $Adjust = $Adjust + 1
					IF $Adjust > GUICtrlRead($Main_MaxShades_inp) Then $Adjust = 0
				Until CheckTimer() or IsArray($Bobber2Pos) = 0
				;MsgBox(0,"ERROR",IsArray($Bobber2Pos)&@CRLF&"<'))>< Caught")
				$Mouse = MouseGetPos()
				ToolTip("<'))>< Caught", $Mouse[0]+10,$Mouse[1]+5)
			;Else
			;	MsgBox(0,"ERROR (1030)","GUICtrlRead($Main_Splash_rdo) = 1")
			;	Stop()
			;EndIf
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;===> PixelSearch Start
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			$Rand = Round(Random(1,100),0)
			If IsArray($Bobber2Pos) = 0 and $Rand <= Guictrlread($Main_MAXAccuracy_inp) Then
				Sleep(Random(50,500))
				While 1
					If GUIGetMsg() = $Stop_btn Then Stop()
					If WinActive($E_Title) = 1 Then
						MouseMove($PixSearch[0], $PixSearch[1], random(0,5))
						Sleep(Random(50,500))
						MouseClick("right", $PixSearch[0], $PixSearch[1], 2, random(0,5))
						$Caught = $Caught + 1
						GUICtrlSetData($Main_Status_lbl, "You caught a <'))><")
						GUICtrlSetData($Main_Caught_lbl, $Caught)
						ToolTip('')
						Sleep(Random(250,1500))
						;MsgBox(0,"WinActive",IsArray($PixSearch)&@CRLF&"<'))>< Caught")
						ExitLoop
					ElseIf WinExists($E_Title) = 1 Then
						WinActivate($E_Title)
						MouseMove($PixSearch[0], $PixSearch[1], random(0,5))
						Sleep(Random(50,500))
						MouseClick("right", $PixSearch[0], $PixSearch[1], 2, random(0,5))
						$Caught = $Caught + 1
						GUICtrlSetData($Main_Status_lbl, "You caught a <'))><")
						GUICtrlSetData($Main_Caught_lbl, $Caught)
						ToolTip('')
						Sleep(Random(250,1500))
						;MsgBox(0,"WinExists",IsArray($PixSearch)&@CRLF&"<'))>< Caught")
						ExitLoop
					ElseIf $Trys = 3 Then
						MsgBox(0,"Error while Casting","Error while Casting"&@CRLF&"Unable to Activate "&$E_Title&" window.",3)
						ExitLoop
					EndIf
					$Trys = $Trys + 1
				WEnd
			Else
				GUICtrlSetData($Main_Status_lbl, "No <'))>< want to play with your worm.")
				ToolTip("Adjust Accuracy", $Mouse[0]+10,$Mouse[1]+5)
				Do
					CheckTimer()
					If GUIGetMsg() = $Stop_btn Then Stop()
				Until 1 = 2
				Bot()
			EndIf
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;===> PixelSearch End
			;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			#EndRegion
		Until $Loop = 1 or $Loop = 3
	Until $Loop = 3
	Main_While()
EndFunc
Func Stop()
	ToolTip("")
	$Stopped = MsgBox(262179,"Paused......",$E_ToDo&" Bot is Paused...." & @CRLF & @CRLF & "Press [Yes] to continue!" & @CRLF & "Press [No] to Stop "&$E_ToDo&"!" & @CRLF & "Press [Cancel] to Restart!")
	Select
		Case $Stopped = 6 ;Yes
			;do nothing
		Case $Stopped = 7 ;No
			GUICtrlSetState($Stop_btn, $gui_hide)
			GUICtrlSetState($Start_btn, $gui_Enable)
			GUICtrlSetState($About_btn, $gui_Enable)
			GUICtrlSetState($Help_btn, $gui_Enable)
			Main_While()
		Case $Stopped = 2 ;Cancel
			Start()
	EndSelect
EndFunc
#EndRegion
#Region
Func Fullscreen()
	If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Starting","You are about to start ", 5);Windowed Mode Only
	If WinExists($E_Title) = 0 Then Exit
	ToolTip("")
	$Old_Mouse = "0,0"
	$dll = DllOpen("user32.dll")
	While -1
		If WinActive($E_Title) = 1 Then
			$Mouse = MouseGetPos()
			IF $Mouse[0]&", "&$Mouse[1] <> $Old_Mouse Then
				ToolTip("Right click when ready to start."&@CRLF&"X:"&$Mouse[0]&",Y:"&$Mouse[1], $Mouse[0]+20,$Mouse[1]+10)
				$Old_Mouse = $Mouse[0]&", "&$Mouse[1]
			EndIf
			If WinActive($E_Title) = 0 Then WinActivate($E_Title) ; Make sure WoW stays active while user is selecting color
			If _IsPressed("02",$dll) Then
				ToolTip("")
				ExitLoop
			EndIf
		Else
			WinActivate($E_Title)
			Sleep(Random(500,1000))
		EndIf
	WEnd
	$Old_Mouse = "0,0"
	$dll = DllOpen("user32.dll")
	Sleep(Random(500,1000))
	If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Setting up","Left click in the top left corner of the search area."&$E_ToDo, 5);Windowed Mode Only
	While -1
		If WinActive($E_Title) = 1 Then
			$Mouse = MouseGetPos()
			IF $Mouse[0]&", "&$Mouse[1] <> $Old_Mouse Then
				ToolTip("Left click in the top left corner of the search area."&@CRLF&"X:"&$Mouse[0]&",Y:"&$Mouse[1], $Mouse[0]+20,$Mouse[1]+10)
				$Old_Mouse = $Mouse[0]&", "&$Mouse[1]
			EndIf
			If WinActive($E_Title) = 0 Then WinActivate($E_Title) ; Make sure WoW stays active while user is selecting color
			If _IsPressed("01",$dll) Then
				GUICtrlSetData($Area_X_inp, $Mouse[0])
				GUICtrlSetData($Area_Y_inp, $Mouse[1])
				ToolTip("")
				ExitLoop ; Exit loop when user left clicks
			EndIf
		Else
			WinActivate($E_Title)
			Sleep(Random(500,1000))
		EndIf
	WEnd
	$Old_Mouse = "0,0"
	Sleep(Random(500,1000))
	If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Setting up","Left click in the bottom right corner of the search area.", 5);Windowed Mode Only
	While -1
		If WinActive($E_Title) = 1 Then
			$Mouse = MouseGetPos()
			IF $Mouse[0]&", "&$Mouse[1] <> $Old_Mouse Then
				ToolTip("Left click in the bottom right corner of the search area."&@CRLF&"X:"&$Mouse[0]&",Y:"&$Mouse[1], $Mouse[0]+20,$Mouse[1]+15)
				$Old_Mouse = $Mouse[0]&", "&$Mouse[1]
			EndIf
			If WinActive($E_Title) = 0 Then WinActivate($E_Title) ; Make sure Wow stays active while user is selecting color
			If _IsPressed("01",$dll) Then
				GUICtrlSetData($Area_Height_inp, $Mouse[0])
				GUICtrlSetData($Area_Width_inp, $Mouse[1])
				ToolTip("")
				ExitLoop ; Exit loop when user left clicks
			EndIf
		Else
			WinActivate($E_Title)
			Sleep(Random(500,1000))
		EndIf
	WEnd
	$Old_Mouse = "0,0"
	Sleep(Random(500,1000))
	If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Setting up","Left click the cast button on you action bar.", 5);Windowed Mode Only
	While -1
		If WinActive($E_Title) = 1 Then
			$Mouse = MouseGetPos()
			IF $Mouse[0]&", "&$Mouse[1] <> $Old_Mouse Then
				ToolTip("Left click the cast button on you action bar."&@CRLF&"X:"&$Mouse[0]&",Y:"&$Mouse[1], $Mouse[0]+20,$Mouse[1]+15)
				$Old_Mouse = $Mouse[0]&", "&$Mouse[1]
			EndIf
			If WinActive($E_Title) = 0 Then WinActivate($E_Title) ; Make sure Wow stays active while user is selecting color
			If _IsPressed("01",$dll) Then
				GUICtrlSetData($MouseX_inp, $Mouse[0])
				GUICtrlSetData($MouseY_inp, $Mouse[1])
				ToolTip("")
				ExitLoop ; Exit loop when user left clicks
			EndIf
		Else
			WinActivate($E_Title)
			Sleep(Random(500,1000))
		EndIf
	WEnd
	$Old_Mouse = "0,0"
	Sleep(Random(500,1000))
	If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Setting up","Left Click to select this color.", 5);Windowed Mode Only
	$gui = GUICreate("",200,200,(@DesktopWidth/2)-100,@DesktopHeight-200,$WS_POPUP,$WS_EX_TOPMOST) ; Create a large borderless GUI that is always on top so user can see the color
	GUISetState(@SW_SHOW)
	While -1
		If WinActive($E_Title) = 1 Then
			$Mouse = MouseGetPos()
			$color = PixelGetColor($mouse[0],$mouse[1])
			IF $Mouse[0]&", "&$Mouse[1] <> $Old_Mouse Then
				ToolTip("Left Click to select this color."&@CRLF&"X:"&$Mouse[0]&",Y:"&$Mouse[1], $Mouse[0]+20,$Mouse[1]+15)
				GUISetBkColor("0x" & Hex($color,6),$gui) ; Update gui with color seen
				GUICtrlSetBkColor($Main_Color_lbl, "0x" & Hex($color,6))
				GUICtrlSetData($Main_Color_lbl, "0x" & Hex($color,6))
				$Old_Mouse = $Mouse[0]&", "&$Mouse[1]
			EndIf
			If WinActive($E_Title) = 0 Then WinActivate($E_Title) ; Make sure Wow stays active while user is selecting color
			If _IsPressed("01",$dll) Then
				ToolTip("")
				ExitLoop ; Exit loop when user left clicks
			EndIf
		Else
			WinActivate($E_Title)
			Sleep(Random(500,1000))
		EndIf
	WEnd
	Sleep(500)
	GUISetState(@SW_HIDE) ; GUI for selecting color no longer needed
	GUIDelete($gui)
	DllClose($dll)
EndFunc
Func ChatCheck()
	If GUIGetMsg() = $Stop_btn Then Stop()
	$ChatSearch = PixelSearch(GUICtrlRead($AutoReply_X_inp), GUICtrlRead($AutoReply_Y_inp),GUICtrlRead($AutoReply_X_inp)+GUICtrlRead($AutoReply_Width_inp),GUICtrlRead($AutoReply_Y_inp)+GUICtrlRead($AutoReply_Height_inp), GUICtrlRead($AutoReplyHex_inp), 15, 1)
	If IsArray($ChatSearch) = 1 Then
		$Chance = Round(Random(1,3),0)
		If $Chance = 3 Then ; Reply
			If @error Then
				MsgBox(4096, "Error 1", "Error occurred, probably no INI file.",3)
			Else
				$Reply = IniRead($IniFile, "Reply Messages", Round(Random(1,9),0), "Dude !")
				Sleep(random(500,1500))
				Send("{Enter}")
				Sleep(random(500,1500))
				Send("/r")
				Sleep(random(500,1500))
				Send("{Space}")
				Sleep(random(500,1500))
				Send($Reply)
				Sleep(random(500,1500))
				Send("{Enter}")
				Sleep(random(1000,2000))
			EndIf
		EndIf
	EndIf
EndFunc
Func DeadCheck()
	If GUIGetMsg() = $Stop_btn Then Stop()
	$DeadSearch = PixelSearch(GUICtrlRead($LifeMouseX_inp)-5, GUICtrlRead($LifeMouseY_inp)-5,GUICtrlRead($LifeMouseX_inp)+5, GUICtrlRead($LifeMouseY_inp)+5, GUICtrlRead($LifeHex_inp), 15, 1)
	If IsArray($DeadSearch) <> 1 Then
		GUICtrlSetData($Main_Status_lbl, "You are dead.")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Dead Check","You are dead.",3);Windowed Mode Only Random[6]
		If WinActive($E_Title) Then
			$DeadCheck = MsgBox(262180,"You are dead !","Are you really Dead ?",5)
			Select
				Case $DeadCheck = 6 ;Yes
					Sleep(random(1000,2000))
					Send("{Enter}")
					Sleep(random(1000,2000))
					Send("/Exit")
					Sleep(random(1000,2000))
					Send("{Enter}")
					Sleep(random(1000,2000))
					Exit
				Case $DeadCheck = 7 ;No
					; Do nothing
				Case $DeadCheck = -1 ;Timeout
					Sleep(random(1000,2000))
					Send("{Enter}")
					Sleep(random(1000,2000))
					Send("/Exit")
					Sleep(random(1000,2000))
					Send("{Enter}")
					Sleep(random(1000,2000))
					Exit
			EndSelect
		Else
			WinActivate($E_Title)
			Sleep(random(1000,2000))
		EndIf
	EndIf
EndFunc
Func RandomAction()
	If GUIGetMsg() = $Stop_btn Then Stop()
	$Action = round(Random(1,7),0)
	If $Action = 1 Then
		$count = Round(Random(1,3),0)
		GUICtrlSetData($Main_Status_lbl, "Random Action ["&$count&"] Random wait time.")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Random Action [1]", "Random wait time.",3);Windowed Mode Only Random[1]
		For $1=1 to $count
			Sleep(random(500,2000))
		Next
	ElseIf $Action =  2 Then
		$count = Round(Random(1,3),0)
		GUICtrlSetData($Main_Status_lbl, "Random Action ["&$count&"] Random mouse moves.")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Random Action [2]", "Random mouse moves",3);Windowed Mode Only Random[2]
		For $1=1 to $count
			MouseMove(random(@DesktopWidth*.10,@DesktopWidth*.95), random(@DesktopHeight*.10,@DesktopHeight*.95), random(0,50))
			Sleep(random(50,1000))
		Next
	ElseIf $Action = 3  Then
		$count = Round(Random(1,3),0)
		GUICtrlSetData($Main_Status_lbl, "Random Action ["&$count&"] Random wait time.")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Random Action [3]", "Random wait time.",3);Windowed Mode Only Random[3]
		For $1=1 to $count
			Sleep(random(500,1000))
		Next
	ElseIf $Action = 4 Then
		GUICtrlSetData($Main_Status_lbl, "Random Action Nonthing...")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Random Action [4]", "Nonthing...",3);Windowed Mode Only Random[4]
		Sleep(random(50,500))
	ElseIf $Action =  5 Then
		$count = Round(Random(1,8),0)
		GUICtrlSetData($Main_Status_lbl, "Random Action ["&$count&"] Checking your bags")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Random Action [5]", "Checking your bags",3);Windowed Mode Only Random[5]
		If WinActive($E_Title) Then
			Send("{B}")
			For $1=1 to $count
				;MouseMove(random(900,1111), random(650,800), random(15,50))
				Sleep(random(50,1000))
			Next
			Send("{B}")
		Else
			For $1=1 to $count
				;MouseMove(random(900,1111), random(650,800), random(15,50))
				Sleep(random(50,1000))
			Next
		EndIf
	ElseIf $Action =  6 Then
		$times = Round(Random(1,2),0)
		GUICtrlSetData($Main_Status_lbl, "Random Action ["&$times&"] Jump(s).")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Random Action [6]", "Random number of jumps",3);Windowed Mode Only Random[6]
		If WinActive($E_Title) Then
			For $1=1 to $times
				Send("{SPACE}")
				Sleep(random(1000,2000))
			Next
		EndIf
	ElseIf $Action =  7 Then
		$random = Round(Random(1,3),0)
		GUICtrlSetData($Main_Status_lbl, "Random Action ["&$random&"] Random mouse moves")
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Random Action [7]", "Random mouse moves",3);Windowed Mode Only Random[7]
		If $random = 1 Then
			MouseMove(random(@DesktopWidth*.30,@DesktopWidth*.70), random(@DesktopHeight*.50,@DesktopHeight*.30), random(5,50))
		ElseIf $random = 2 Then
			MouseMove(random(@DesktopWidth*.25,@DesktopWidth*.75), random(@DesktopHeight*.475,@DesktopHeight*.20), random(5,50))
		EndIf
		Sleep(Random(50,1000))
	EndIf
EndFunc
Func CheckTimer()
	If GUIGetMsg() = $Stop_btn Then Stop()
	$dif = TimerDiff($Timer)
	GUICtrlSetData($Main_Timer_lbl, StringTrimRight(Round($dif,0),3))
	If StringTrimRight(Round($dif,0),0) >= GUICtrlRead($Main_MAXTimer_inp)*1000 Then
		If GUICtrlRead($WinMode_cbx) = 1 Then TrayTip("Times Up !", "Try again !", 3);Windowed Mode Only
		GUICtrlSetData($Main_Status_lbl, "Times Up!")
		Sleep(Random(1000,2000))
		Start()
	EndIf
EndFunc
Func StopTimer()
	If GUIGetMsg() = $Stop_btn Then Stop()
	IF GUICtrlRead($CurrentTime) >= GUICtrlRead($Main_Untill_Time) Then
		$Exit = 0
		Do
			If WinActive($E_Title,"") Then
				Send("{ENTER}")
				Sleep(Random(500,2000))
				Send("/Exit")
				Sleep(Random(500,2000))
				Send("{ENTER}")
				Sleep(Random(500,2000))
				$Exit = 1
			Else
				WinActivate($E_Title,"")
			EndIf
		Until $Exit = 1
		Exit
	EndIf
EndFunc
Func Click($MouseX,$MouseY)
	If GUIGetMsg() = $Stop_btn Then Stop()
	ToolTip("")
	$Old_Mouse = "0,0"
	$dll = DllOpen("user32.dll")
	While 1
		$Mouse = MouseGetPos()
		If _IsPressed("01", $dll) Then
			GUICtrlSetData($MouseX,$Mouse[0])
			GUICtrlSetData($MouseY,$Mouse[1])
			ExitLoop
		ElseIf _IsPressed("02", $dll) Then
			$X = GUICtrlRead($MouseX)
			$Y = GUICtrlRead($MouseY)
			MouseMove($X,$Y,1000)
			ExitLoop
		EndIf
		IF $Mouse[0]&", "&$Mouse[1] <> $Old_Mouse Then
			ToolTip("<--- Move the mouse to desired position."&@CRLF&"X:"&$Mouse[0]&",Y:"&$Mouse[1], $Mouse[0]+10,$Mouse[1]+5)
			$Old_Mouse = $Mouse[0]&", "&$Mouse[1]
		EndIf
	WEnd
	DllClose($dll)
	ToolTip("")
EndFunc
Func SetColor($Color_lbl, $ColorHex, $ColorMouseX, $ColorMouseY)
	dim $color = ''
	ToolTip("")
	$Old_Mouse = "0,0"
	$dll = DllOpen("user32.dll")
	$Old_Color = GUICtrlRead($ColorHex)
	While -1
		$Mouse = MouseGetPos()
		If _IsPressed("01", $dll) Then
			GUICtrlSetData($ColorHex, "0x" & Hex($color,6))
			GUICtrlSetData($ColorMouseX, $Mouse[0])
			GUICtrlSetData($ColorMouseY, $Mouse[1])
			ExitLoop
		ElseIf _IsPressed("02", $dll) Then
			GUICtrlSetData($ColorHex, $Old_Color)
			GUICtrlSetBkColor($Color_lbl, $Old_Color)
			$X = GUICtrlRead($ColorMouseX)
			$Y = GUICtrlRead($ColorMouseY)
			MouseMove($X,$Y,1000)
			ExitLoop
		EndIf
		IF $Mouse[0]&", "&$Mouse[1] <> $Old_Mouse Then
			$color = PixelGetColor($Mouse[0],$Mouse[1])
			ToolTip("<--- Left Click to select this color."&@CRLF&"Hex: 0x" & Hex($color,6)&"       X:"&$Mouse[0]&",Y:"&$Mouse[1], $Mouse[0]+10,$Mouse[1]+5) ; Create a Tooltip away from cursor that the user can use to select a color, mousing over bobber changes its color!
			GUICtrlSetBkColor($Color_lbl, "0x" & Hex($color,6))
			$Old_Mouse = $Mouse[0]&", "&$Mouse[1]
		EndIf
	WEnd
	DllClose($dll)
	ToolTip("")
EndFunc
Func CastOrder()

EndFunc
Func Window()
	If WinGetProcess($E_Title) = ProcessExists($E_Title2&".exe") Then
		$WinPos = WinGetPos($E_Title)
		$WinState = WinGetState($E_Title)
		Select
			Case $Win_Error <> 2 And BitAnd($WinState, 8)
				GUICtrlSetData($WindowDisplay, "")
				GUICtrlSetData($WindowDisplay, $E_Title)
				GUICtrlSetColor($WindowDisplay, 0x008000)
				Global $Win_Error = 2
				GUICtrlSetData($Main_Status_lbl, $E_Title2&" Window (Active)")
			Case $Win_Error <> 3 And BitAnd($WinState, 16)
				GUICtrlSetData($WindowDisplay, "")
				GUICtrlSetData($WindowDisplay, "Minimized")
				GUICtrlSetColor($WindowDisplay, 0x800000)
				Global $Win_Error = 3
				GUICtrlSetData($Main_Status_lbl, $E_Title2&" Window (Minimized)")
		EndSelect
	ElseIf $Win_Error <> 1 Then
		GUICtrlSetData($WindowDisplay, "")
		GUICtrlSetData($WindowDisplay, $E_Title2&" not Found.")
		GUICtrlSetColor($WindowDisplay, 0x800000)
		GUICtrlSetData($Main_Status_lbl, $E_Title2&" Window (Not Found)")
		Global $Win_Error = 1
	EndIf
EndFunc
Func SetArea($What, $X, $Y, $Height, $Width)
	If GUICtrlRead($X) = "" and GUICtrlRead($Y) = "" Then
		$Area_W = Round((@DesktopWidth*.75)-(@DesktopWidth*.25),0);1280(960-320= 640)
		$Area_H = Round((@DesktopHeight*.45)-(@DesktopHeight*.20),0);1000(450-200= 250)
		$Area_Y = Round(@DesktopHeight*.20,0);1000*.20 = 200
		$Area_X = Round((@DesktopWidth*.50)-($Width*.50),0);(1280*.50=644)-(644*.50=322)=322
	Else
		$Area_X = GUICtrlRead($X)
		$Area_Y = GUICtrlRead($Y)
		$Area_H = GUICtrlRead($Height)
		$Area_W = GUICtrlRead($Width)
	EndIf
	$Area = GUICreate($What, $Area_W, $Area_H, $Area_X, $Area_Y, $WS_SIZEBOX,$WS_EX_TOPMOST)
	GUISetState(@SW_SHOW, $Area)
	GUISetBkColor(0x0)
	$Area_btn = GUICtrlCreateButton("Click when Ready?",0,0)
	GUICtrlSetResizing ($Area_btn,$GUI_DOCKHCENTER+$GUI_DOCKAUTO)
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	;===>
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	While 1
		$Msg_1 = GUIGetMsg()
		Select
			Case $Msg_1 = $Area_btn
				$Area_pos = WinGetPos($What,"Click when Ready?"); x[0], y[1], width[2], height[3]
				$Area_Left = $Area_pos[0];X
				$Area_Top = $Area_pos[1]; Y
				$Area_Width = $Area_pos[2]; W
				$Area_Height = $Area_pos[3]; H
				$Area_Bottom = $Area_Top + $Area_pos[3]; Y + H
				$Area_Right = $Area_Left + $Area_pos[2]; X + W

				GUICtrlSetData($X, Round($Area_pos[0],0));x
				GUICtrlSetData($Y, Round($Area_pos[1],0));y
				GUICtrlSetData($Width, Round($Area_pos[2],0)-14);W
				GUICtrlSetData($Height, Round($Area_pos[3],0)-14);H
				ExitLoop
		EndSelect
		Sleep(Random(10,50))
	Wend
	GUIDelete($Area)
	Sleep(Random(100,500))
EndFunc
Func DND()
	If $DND_Check <> 1 Then
		If GUICtrlRead($DND_cbx) = 1 Then
			If WinActive($E_Title,"") Then
				Send("{ENTER}")
				Sleep(Random(1000,2000))
				Send("/DND "&GUICtrlRead($DND_cbo))
				Sleep(Random(1000,2000))
				Send("{ENTER}")
				Sleep(Random(1000,2000))
				$DND_Check = 1
			EndIf
		EndIf
	EndIf
EndFunc
Func ModeCheck()
	If IniRead($IniFile,"Mode", "Start", "") <> "1" Then
		Global $Timer2 = TimerInit()
		IniWrite($IniFile,"Mode", "Start",1)
	EndIf
	IF IniRead($IniFile,"Mode", "Timer", "") = "0" Then
		$W_State = GUICtrlRead($WinMode_cbx)
		$WinPos = WinGetPos($E_Title)
		Sleep(Random(500,1000))
		$L1 = IniRead($IniFile,"Mode", "Mode1", "")
		$L2 = IniRead($IniFile,"Mode", "Mode2", "")
		$L3 = IniRead($IniFile,"Mode", "Mode3", "")
		$L4 = IniRead($IniFile,"Mode", "Mode4", "")
		$L5 = IniRead($IniFile,"Mode", "Mode5", "")
		If GUICtrlRead($Mode_cbx_1) = 1 Then
			If $L1 > 0 Then
				Timer($Timer2)
				MouseClick("Left",IniRead($IniFile,"Mode", "ModeX1", ""),IniRead($IniFile,"Mode", "ModeY1", ""),random(5,50))
				GUICtrlSetData($Mode_inp_1,$L1-1)
				IniWrite($IniFile,"Mode", "Mode1",$L1-1)
				Sleep(6000)
				IniWrite($IniFile,"Mode", "Timer",10*60000)
			EndIf
		ElseIf GUICtrlRead($Mode_cbx_2) = 1 Then
			IF $L2 > 0 Then
				Timer($Timer2)
				MouseClick("Left",IniRead($IniFile,"Mode", "ModeX2", ""),IniRead($IniFile,"Mode", "ModeY2", ""),random(5,50))
				GUICtrlSetData($Mode_inp_1,$L1-1)
				IniWrite($IniFile,"Mode", "Mode1",$L1-1)
				Sleep(6000)
				IniWrite($IniFile,"Mode", "Timer",10*60000)
			EndIf
		ElseIf GUICtrlRead($Mode_cbx_3) = 1 Then
			If $L3 > 0 Then
				Timer($Timer2)
				MouseClick("Left",IniRead($IniFile,"Mode", "ModeX3", ""),IniRead($IniFile,"Mode", "ModeY3", ""),random(5,50))
				GUICtrlSetData($Mode_inp_1,$L1-1)
				IniWrite($IniFile,"Mode", "Mode1",$L1-1)
				Sleep(6000)
				IniWrite($IniFile,"Mode", "Timer",10*60000)
			EndIf
		ElseIf GUICtrlRead($Mode_cbx_4) = 1 Then
			If $L4 > 0 Then
				Timer($Timer2)
				MouseClick("Left",IniRead($IniFile,"Mode", "ModeX4", ""),IniRead($IniFile,"Mode", "ModeY4", ""),random(5,50))
				GUICtrlSetData($Mode_inp_1,$L1-1)
				IniWrite($IniFile,"Mode", "Mode1",$L1-1)
				Sleep(6000)
				IniWrite($IniFile,"Mode", "Timer",10*60000)
			EndIf
		ElseIf GUICtrlRead($Mode_cbx_5) = 1 Then
			If $L5 > 0 Then
				Timer($Timer2)
				MouseClick("Left",IniRead($IniFile,"Mode", "ModeX5", ""),IniRead($IniFile,"Mode", "ModeY5", ""),random(5,50))
				GUICtrlSetData($Mode_inp_1,$L1-1)
				IniWrite($IniFile,"Mode", "Mode1",$L1-1)
				Sleep(6000)
				IniWrite($IniFile,"Mode", "Timer",10*60000)
			EndIf
		EndIf
	Else
		Timer($Timer2)
	EndIf
EndFunc
Func Timer($Timer2)
	If TimerDiff($Timer2) >= IniRead($IniFile,"Mode", "Timer", "") Then
		IniWrite($IniFile,"Mode", "Timer", "0")
		IniWrite($IniFile,"Mode", "Start", "0")
	EndIf
EndFunc
#EndRegion