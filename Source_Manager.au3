#include <GUIConstants.au3>
#include <GUIEdit.au3>
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>

Opt("WinTitleMatchMode", 2)
Global $current_date = @MDAY & ". " & @MON & ". " & @YEAR ; Get Current Date

; =============================================================Settings=============================================================

Global Const $ui_width = 600, $ui_height = 400, $ui_margin = 5
Global Const $button_width = 70, $button_height = 20
Global Const $input_width = 200, $input_height = 20
Global Const $configfolder = @AppDataDir
Global Const $iniconfig = $configfolder & "\QM_Config.ini"
Global Const $inisources = $configfolder & "\QM_Sources.ini"
Global $i = 0

; =============================================================GUI=============================================================

Global $hGui = GUICreate("Quellen Manager", $ui_width, $ui_height) ; Create Gui
Global $tab = GUICtrlCreateTab(0, 0, $ui_width, $ui_height) ; Create Tab Group
Global $button_cancel = GUICtrlCreateButton("Abbrechen", $ui_width-$button_width-$ui_margin, $ui_height-$button_height-$ui_margin, $button_width, $button_height) ; Cancel Button

; =============================================================Paste Tab=============================================================

; Paste Tab
Global $tab_paste = GUICtrlCreateTabItem("Einfügen")
; Input Title
Global $input_title = GUICtrlCreateInput("", $ui_margin, 21+$ui_margin, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_title, "Titel", True)
; Input URL
Global $input_url = GUICtrlCreateInput("", $ui_margin, 21+2*$ui_margin+1*$input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_url, "URL", True)
; Input Name
Global $input_name = GUICtrlCreateInput("", $ui_margin, 21+3*$ui_margin+2*$input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_name, "Vorname", True)
; Input Last Name
Global $input_lastname = GUICtrlCreateInput("", $ui_margin, 21+4*$ui_margin+3*$input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_lastname, "Nachname", True)
; Input Year
Global $input_year = GUICtrlCreateInput("", $ui_margin, 21+5*$ui_margin+4*$input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_year, "Jahr", True)
; Input Date
Global $input_date = GUICtrlCreateInput("", $ui_margin, 21+6*$ui_margin+5*$input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_date, "Datum", True)
; Input Index
Global $input_index = GUICtrlCreateInput("", $ui_margin, 21+7*$ui_margin+6*$input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_index, "Index", True)
; Buttons
Global $button_ok = GUICtrlCreateButton("OK", $ui_margin, $ui_height-$button_height-$ui_margin, $button_width, $button_height)
Global $button_clear = GUICtrlCreateButton("Löschen", 2*$ui_margin+$button_width, $ui_height-$button_height-$ui_margin, $button_width, $button_height)
Global $checkbox_keepdate = GUICtrlCreateCheckbox("Datum beibehalten?", 2*$ui_margin+$input_width+5, 21+6*$ui_margin+5*$input_height) ; Checkbox to keep date when $button_clear

; =============================================================Settings Tab=============================================================
; Tab Settings
Global $tab_settings = GUICtrlCreateTabItem("Einstellungen")
Global $button_save = GUICtrlCreateButton("Speichern", $ui_margin, $ui_height-$button_height-$ui_margin, $button_width, $button_height) ; Save Button
; Input Window to Activate
Global $input_windowname = GUICtrlCreateInput("", $ui_margin, 21+$ui_margin, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_windowname, "Fenstername", True)

Load_Config()
GUISetState(@SW_SHOW)

While True
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE ; Exit
			Exit
		Case $button_cancel ; Exit
			Exit
		Case $button_clear ; Clear Inputs
			GUICtrlSetData($input_title, "")
			GUICtrlSetData($input_url, "")
			GUICtrlSetData($input_name, "")
			GUICtrlSetData($input_lastname, "")
			GUICtrlSetData($input_year, "")
			GUICtrlSetData($input_index, "")
			If Guictrlread($checkbox_keepdate) = $GUI_UNCHECKED Then GUICtrlSetData($input_date, "")
		Case $button_ok
			Read_Inputs()
			Input_Data()
		
		Case $button_save
			Read_Inputs()
			Save_Config()		
	EndSwitch
WEnd

Func Read_Inputs() ; Save Inputfields
	Global $title = GUICtrlRead($input_title)
	Global $url = GUICtrlRead($input_url)
	Global $url_modified = Modify_Url($url)
	Global $name = GUICtrlRead($input_name)
	Global $lastname = GUICtrlRead($input_lastname)
	Global $year = GUICtrlRead($input_year)
	Global $date = GUICtrlRead($input_date)
	Global $index = GUICtrlRead($input_index)
	Global $windowname = GUICtrlRead($input_windowname)
	Global $keepdate = GUICtrlRead($checkbox_keepdate)
EndFunc

Func Save_Config() ; Saves Settings to INI File
	IniWrite($iniconfig, "settings", "windowname", $windowname)
	IniWrite($iniconfig, "settings", "keepdate", Guictrlread($checkbox_keepdate))
EndFunc

Func Load_Config() ; Load Settings from INI File
	GUICtrlSetData($input_windowname, IniRead($iniconfig, "settings", "windowname", ""))
	GUICtrlSetState($checkbox_keepdate, IniRead($iniconfig, "settings", "keepdate", ""))
EndFunc

Func Input_Data() ; Inputs correctly formated Data
	If WinExists($windowname) Then
		WinActivate($windowname)

		If $index <> "" Then Send("[" & $index & "] ")
		If $index = "" Then Send("- ")

		If $lastname <> "" Then Send($lastname & ", ")

		Send($name)

		If $year <> "" Then Send(" (" & $year & "): ")
		If $year = "" Then Send(": ")

		Send($title & ". URL: " & $url_modified & " [Stand: " & $date & "].{Enter}")
	Else
		MsgBox($MB_SYSTEMMODAL, "Quellen Manager", $windowname & " exsistiert nicht.")
	EndIf
EndFunc

Func Modify_Url($url) ; Modifies the $url so "#" can be Send()
	Local $url2 = StringReplace($url, "#", "{#}")
	Return $url2
EndFunc