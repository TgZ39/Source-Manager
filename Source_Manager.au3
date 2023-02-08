; *** Start added by AutoIt3Wrapper ***
#include <GUIConstantsEx.au3>
; *** End added by AutoIt3Wrapper ***
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=build\Source_Manager_x86.Exe
#AutoIt3Wrapper_Outfile_x64=build\Source_Manager_x64.Exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstants.au3>
#include <GUIEdit.au3>
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>
#include <UpDownConstants.au3>

Opt("WinTitleMatchMode", 2)

; =============================================================Settings=============================================================

Global Const $ui_width = 600, $ui_height = 400, $ui_margin = 5
Global Const $button_width = 70, $button_height = 20
Global Const $input_width = 200, $input_height = 20
Global Const $configfolder = @AppDataDir
Global Const $iniconfig = $configfolder & "\QM_Config.ini"
;~ Global Const $inisources = $configfolder & "\QM_Sources.ini"
Global $i = 0

; =============================================================GUI=============================================================

Load_Language()

Global $hGui = GUICreate($language_title, $ui_width, $ui_height) ; Create Gui
Global $tab = GUICtrlCreateTab(0, 0, $ui_width, $ui_height) ; Create Tab Group
Global $button_cancel = GUICtrlCreateButton($language_button_cancel, $ui_width - $button_width - $ui_margin, $ui_height - $button_height - $ui_margin, $button_width, $button_height) ; Cancel Button

; =============================================================Paste Tab=============================================================

; Paste Tab
Global $tab_paste = GUICtrlCreateTabItem($language_tab_paste)
; Input Title
Global $input_title = GUICtrlCreateInput("", $ui_margin, 21 + $ui_margin, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_title, $language_input_title, True)
; Input URL
Global $input_url = GUICtrlCreateInput("", $ui_margin, 21 + 2 * $ui_margin + 1 * $input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_url, "URL", True)
; Input Name
Global $input_name = GUICtrlCreateInput("", $ui_margin, 21 + 3 * $ui_margin + 2 * $input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_name, $language_input_name, True)
; Input Last Name
Global $input_lastname = GUICtrlCreateInput("", $ui_margin, 21 + 4 * $ui_margin + 3 * $input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_lastname, $language_input_lastname, True)
; Input Year
Global $input_year = GUICtrlCreateInput("", $ui_margin, 21 + 5 * $ui_margin + 4 * $input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_year, $language_input_year, True)
; Input Date
Global $input_date = GUICtrlCreateInput("", $ui_margin, 21 + 6 * $ui_margin + 5 * $input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_date, $language_input_date, True)
; Input Index
Global $input_index = GUICtrlCreateInput("", $ui_margin, 21 + 7 * $ui_margin + 6 * $input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_index, $language_input_index, True)
GUICtrlCreateUpdown($input_index)
; Buttons
; Ok button
Global $button_ok = GUICtrlCreateButton("OK", $ui_margin, $ui_height - $button_height - $ui_margin, $button_width, $button_height)
; Clear inputfields button
Global $button_clear = GUICtrlCreateButton($language_button_clear, 2 * $ui_margin + $button_width, $ui_height - $button_height - $ui_margin, $button_width, $button_height)
; Checkbox do determain if date inputfield should be cleared when clear button is pressed
Global $checkbox_keepdate = GUICtrlCreateCheckbox($language_checkbox_keepdate, 3 * $ui_margin + $input_width + $button_width + 20, 21 + 6 * $ui_margin + 5 * $input_height)
Global $checkbox_keepindex = GUICtrlCreateCheckbox($language_checkbox_keepindex, 3 * $ui_margin + $input_width, 21 + 7 * $ui_margin + 6 * $input_height)
; Button to fill in current date
Global $button_currentdate = GUICtrlCreateButton($language_button_currentdate, 2 * $ui_margin + $input_width, 21 + 6 * $ui_margin + 5 * $input_height, $button_width + 20, $button_height)


; =============================================================Settings Tab=============================================================
; Tab Settings
Global $tab_settings = GUICtrlCreateTabItem($language_tab_settings)
Global $button_save = GUICtrlCreateButton($language_button_save, $ui_margin, $ui_height - $button_height - $ui_margin, $button_width, $button_height) ; Save Button
; Input Window to Activate
Global $input_windowname = GUICtrlCreateInput("", $ui_margin, 21 + $ui_margin, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_windowname, $language_input_windowname, True)
; Inputbox for custom prefix
Global $input_prefix = GUICtrlCreateInput("", $ui_margin, 21 + 2 * $ui_margin + $input_height, $input_width, $input_height)
_GUICtrlEdit_SetCueBanner($input_prefix, $language_input_customprefix, True)
; Combo for selecting language
Global $combo_language = GUICtrlCreateCombo("Deutsch", $ui_margin, 21 + 3 * $ui_margin + 2 * $input_height, $input_width, $input_height)
GUICtrlSetData($combo_language, "English")

Load_Config()
GUISetState(@SW_SHOW)

While True
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE ; Exit
			Exit
		Case $button_cancel ; Exit
			Exit
			Save_Config()
		Case $button_clear ; Clear Inputs
			GUICtrlSetData($input_title, "")
			GUICtrlSetData($input_url, "")
			GUICtrlSetData($input_name, "")
			GUICtrlSetData($input_lastname, "")
			GUICtrlSetData($input_year, "")
			If GUICtrlRead($checkbox_keepdate) = $GUI_UNCHECKED Then GUICtrlSetData($input_date, "")
			If GUICtrlRead($checkbox_keepindex) = $GUI_UNCHECKED Then GUICtrlSetData($input_index, "")
		Case $button_ok
			Read_Inputs()
			Input_Data()

		Case $button_save
			Read_Inputs()
			Save_Config()
		Case $button_currentdate
			GUICtrlSetData($input_date, @MDAY & ". " & @MON & ". " & @YEAR)
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
	Global $prefix = GUICtrlRead($input_prefix)
	Global $keepdate = GUICtrlRead($checkbox_keepdate)
EndFunc   ;==>Read_Inputs

Func Save_Config() ; Saves Settings to INI File
	IniWrite($iniconfig, "settings", "windowname", GUICtrlRead($input_windowname))
	IniWrite($iniconfig, "settings", "prefix", GUICtrlRead($input_index))
	IniWrite($iniconfig, "settings", "keepdate", GUICtrlRead($checkbox_keepdate))
	IniWrite($iniconfig, "settings", "keepindex", GUICtrlRead($checkbox_keepindex))
	IniWrite($iniconfig, "settings", "language", GUICtrlRead($combo_language))
EndFunc   ;==>Save_Config

Func Load_Config() ; Load Settings from INI File
	GUICtrlSetData($input_windowname, IniRead($iniconfig, "settings", "windowname", "Word")) ; Save Windowname
	GUICtrlSetData($input_prefix, IniRead($iniconfig, "settings", "prefix", ""))
	GUICtrlSetState($checkbox_keepdate, IniRead($iniconfig, "settings", "keepdate", "")) ; Save if the Date should be keept when pressing clear
	GUICtrlSetState($checkbox_keepindex, IniRead($iniconfig, "settings", "keepindex", ""))
	GUICtrlSetData($combo_language, IniRead($iniconfig, "settings", "language", "Deutsch")) ; Load selected Language
EndFunc   ;==>Load_Config

Func Input_Data() ; Inputs correctly formated Data
	If WinExists($windowname) Then
		WinActivate($windowname)

		If $index <> "" Then Send("[" & $index & "] ")
		If $index = "" Then Send($prefix & " ")

		If $lastname <> "" Then Send($lastname & ", ")

		Send($name)

		If $year <> "" Then Send(" (" & $year & "): ")
		If $year = "" Then Send(": ")

		Send($title & ". URL: " & $url_modified & " [Stand: " & $date & "].{Enter}")
	Else
		MsgBox($MB_SYSTEMMODAL, $language_input_windowname, $windowname & $language_msgbox_windowdoesntexsist)
	EndIf
EndFunc   ;==>Input_Data

Func Modify_Url($url) ; Modifies the $url so "#" can be Send()
	Local $url2 = StringReplace($url, "#", "{#}")
	Return $url2
EndFunc   ;==>Modify_Url

Func Load_Language()
	Switch IniRead($iniconfig, "settings", "language", "Deutsch")
		Case "English"
			Global $language_title = "Source Manger"
			Global $language_input_title = "Title"
			Global $language_input_name = "Name"
			Global $language_input_lastname = "Lastname"
			Global $language_input_year = "Year"
			Global $language_input_date = "Date"
			Global $language_input_index = "Index (keep empty for prefix)"
			Global $language_button_currentdate = "Current Date"
			Global $language_checkbox_keepdate = "Keep current Date?"
			Global $language_checkbox_keepindex = "Keep Index?"
			Global $language_button_clear = "Clear"
			Global $language_button_cancel = "Cancel"
			Global $language_tab_paste = "Pase"
			Global $language_tab_settings = "Settings"
			Global $language_input_windowname = "Windowname"
			Global $language_input_customprefix = "Prefix"
			Global $language_button_save = "Save"
			Global $language_msgbox_windowdoesntexsist = " does not exsist."
		Case Else
			Global $language_title = "Quellen Manager"
			Global $language_input_title = "Titel"
			Global $language_input_name = "Vorname"
			Global $language_input_lastname = "Nachname"
			Global $language_input_year = "Jahr"
			Global $language_input_date = "Datum"
			Global $language_input_index = "Index (leer lassen für Präfix)"
			Global $language_button_currentdate = "Aktuelles Datum"
			Global $language_checkbox_keepdate = "Datum beibehalten?"
			Global $language_checkbox_keepindex = "Index beibehalten?"
			Global $language_button_clear = "Löschen"
			Global $language_button_cancel = "Abbrechen"
			Global $language_tab_paste = "Einfügen"
			Global $language_tab_settings = "Einstellungen"
			Global $language_input_windowname = "Fenstername"
			Global $language_input_customprefix = "Präfix"
			Global $language_button_save = "Speichern"
			Global $language_msgbox_windowdoesntexsist = " exsistiert nicht."
	EndSwitch
EndFunc