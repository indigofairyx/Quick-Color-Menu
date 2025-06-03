;!!!!!!!!!! +!IMPORTANT!+ THIS FILE MUST BE ENCODED WITH UTF8+BOM !!!!!!!!!!

; HEADER *******************************************************************
;***************************************************************************
; Name .........: New AutoHotkey Script
; Filename .....: New AutoHotkey Script.ahk
; Written - Tested on ...
; AHK Version ..: 1.1.33+ (Unicode 64-bit)
; OS Version ...: Windows 10
; Language .....: English (en-US)
; Author .......: Xavier
; Github .......: https://github.com/IndigoFairyX/Quick-Color-Menu/
; Forum Link ...: 
; Date .........: Monday, April 7, 2025 2:00 PM
; Last Modified.: v.2025.05.21
;***************************************************************************

; CHANGELOG ;****************************************************************
Changelog := "
(
; CHANGELOG ****************************************************************
; Legend: (+) NEW|ADDED, (*) CHANGED, (!) FIXED, (-) REMOVED
;---------------------------------------------------------------------------
; v.2025.04.13

; + added hex alpaha channels submenu

; 	+ these act independently of the hex colors. this submenu should only send or copy the left column ##, thou will send the ##% if set to in settings. alpha channels should either come before or after the hex DEPENDING on the hex system you're using, which is why i left them menu to column work on the two numbers. its mostly here for reference.

; ! fixed... a RegEx ErrorLevel detection with RGB codes in the clipboard

; + add an option\toggle to hide the task tray icon to the settings menu. !!** if set you'll only be able the color menu, in any fastion, using the hotkey that opens the menu.

;---------------------------------------------------------------------------
; v.2025.05.15 
; + added British spelling of Colour to window detection rules
; + added German spelling of Farbe to window detection rules
; * updated URL to QCM's Github page.

;---------------------------------------------------------------------------
; v.2025.05.17

; ! Fixed typo in the INI for TextEditor which for opening editing the INI file ( or Script if your running the .ahk )

; + added support for Windows Color Dialog Windows `ahk_class #32770` that should now work regardless of system Language. Previously it was looking for the word 'Color' in the title of the window. now its counting the 6 Edit Controls these windows contain. 

; !+ Hotkey items not showing on menu if set in the INI

; ++ Added ( *Limited* ) support for some older version of **Photoshop**. e.g. CS6 ~ 2023 ish. *Not sure what current Photoshop build are looking like*. QCM can change, and read, the the color in this window via sending the HEX code the #HTML color field. it's a wee big buggy on photoshops end, thou it works 85% of the time.

; GUI IMPROMENTS

; + Added Colorful Headings Groupboxs in the Settings Tab for easier Reading.

; Added a few Hotkeys to the 'ECM Show Color' GUIS, also Added The Tray menu Icon with a tooltip Showing the when you hover over it. 



;---------------------------------------------------------------------------
; v.2025.05.19
; - Removed info tabs from settings window as they are now in the ReadMe.md

; GUI IMPROMENTS
; + Added a Toolbar GUI.
; + Both GUIs, when closed, will remember their individual positions, and will reopen if they were open when you exited\reloaded the app.
; + Full Dark and Light Themes Support on GUIs
; ! BUG FIX ! -Removed a random hotkey used in testing that was accidentally left in app
; + added optional Hex & HTLM-Named Color Reference Menus ( the HTML menu is not operational yet)
; + a few updates to the readme.md
;---------------------------------------------------------------------------
; v.2025.05.20

; + added ingertration support for a couple freeware colors pickers, [Just Color Picker](https://annystudio.com/software/colorpicker/) and [ColorMania](https://www.blacksunsoftware.com/colormania.html).

	; if you use these, paste the path the .exe in the `-SETTINGS.ini`, QCM will be able to launch them and read the HEX color they displaying for expedited saving through the `+ Add Color` menu.
	
; +  The toolbar now has adjustable button size via a sub-menu from the setting menu you can set icon\button size between 16 and 48 pixels.

; * updates to the `readme.md`

; + add an option to show the toolbar automatically on app start up, on by Default

; + added a message box warning to **Hide Tray Icon** option

;---------------------------------------------------------------------------
; v.2025.05.21  
; ! fixed color picker icons now show in menus
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
; YYYYMMDD  
; + Change Description
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
; YYYYMMDD  
; + Change Description
;---------------------------------------------------------------------------
; **************************************************************************
)"

;***************************************************************************
; DARK CONTEXT MENU CODE ***************************************************

	MenuDark(Dark:=2) { ;<<==<-CHANGE DEFAULT HERE. Only the # has to be changed.
    static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
    DllCall(SetPreferredAppMode, "int", Dark)
    DllCall(FlushMenuThemes)
	;https://stackoverflow.com/a/58547831/894589
}
darkmode := True
MenuDark()  ; toggle command for DarkMode change

;***************************************************************************
	inifile := A_ScriptDir "\Quick Color Menu -SETTINGS.ini"
global inifile
if !FileExist(inifile)
	{
		gosub makeini ; Creates a new ini file if its not found .
		Sleep 1000
		ToolTip, Your settings file was not found.`nCreating a new one. One moment please.
		Sleep 2000
		ToolTip
		Sleep 200
	}
	
; GLOBAL SCRIPT SETTINGS ***************************************************
#Requires Autohotkey v1.1.+
#SingleInstance, Force ; Allow only one running instance of script
#Persistent ; Keep script permanently running until terminated
#NoEnv ; Avoid checking empty variables to see if they are environment variables
#Warn ; Enable warnings to assist with detecting common errors
#MaxThreads 255
#MaxThreadsPerHotkey 5
SendMode, Input ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir, %A_ScriptDir% ; Change the working directory of the script
SetBatchLines, -1 ; Run script at maximum speed
; #InstallMouseHook ; Forces the unconditional installation of the mouse hook.
; #InstallKeybdHook ; Forces the unconditional installation of the keyboard hook.
SetTitleMatchMode, 2

Menu, Tray, UseErrorLevel
#warn, all, Off
#warn useenv, off
listlines, off

; if (A_IsCompiled)
	; {
		; menu, tray, UseErrorLevel
		; #warn, all, Off
		; #warn useenv, off
	; }

;***************************************************************************
; VARIABLES ****************************************************************

scriptname := "Quick Color Menu"
firstrelase := "v.2025.04.07"
lastupdate := "v.2025.05.17"
githuburl := "https://github.com/indigofairyx/Quick-Color-Menu"
Global Icons := A_ScriptDir  "\Icons\" ; Path to the Icons folder
; Global Icons := A_ScriptDir  "\Icons" ; Path to the Icons folder
Global Tiles := A_Scriptdir "\Color Menu Tiles\"
; Global Tiles := A_Scriptdir "\Color Menu Tiles"
Global GUIVis := 0
Global ToolVis := 0
global xg, yg, xt, yt
pinFF=%icons%\pinFF.ico
pinNN=%icons%\pinNN.ico
global pinFF, pinNN, pinstartpic
global Pin := 1


if !FileExist(Tiles)
	FileCreateDir,%Tiles%
	
if (A_username != "CLOUDEN")
	XColor := False
global XColor

global r, g, b
Description := "A Simple Context Menu for Quickly Storing and Pasting HEX and RGB Color Codes"
global Description
OnExit("ExitHandler") ; Clean up GDI+ on exit

;***************************************************************************
; INIFile ****************************************************************



INIReadSection("ColorMenuOptions")
INIReadSection("QCMConfig")

INIReadSection("Global_Hotkeys") ;; this one feeds the live previews on menu items
INIReadGlobal_Hotkeys() ;; this function turn the hotkeys on
global LabelName, HotkeyValue

INIReadSection("Programs")
global justcolorpicker
global ColorMania
global ShareX
global texteditor
global colorpicker1
global colorpicker2


if (DarkMode)
	{
		DarkMode := true
		MenuDark(2) ; Set to ForceDark
	}
	else
	{
		DarkMode := false
		MenuDark(3) ; Set to ForceLight
	}
	

; if (showhtml16menu)
	; gosub buildHtml16Menu
		
; gosub setmenu
gosub BuildColorMenu


;***************************************************************************
; TRAY MENU ****************************************************************

iconerror := Icons "\iconerror.ico"
global iconerror

menu, tray, NoStandard
;#NoTrayIcon ; Disable the tray icon of the script ;; #todo make this optional in ini
trayicon := Icons "\Icons_039_COLORWHEELCUT_256x256.ico"
; traytiptext =
; (
; %Scriptname%
; %Description%
; )
traytiptext =
(
%A_ScriptName%
%Description%
)

iniread, default4tray, %inifile%, ColorMenuOptions, DefaultTrayDBLClickAction
global default4tray
; 1 = Show The Main Menu, 2 = Show QCM Toolbar, 3 = Show Quick Setting Menu, 4 = Show Settings Window

global trayicon
Menu, Tray, Tip, %traytiptext%
Menu, tray, add, Show Color Menu`t%OpenColorMenu%, ShowColorMenu
Menu, tray, icon, Show Color Menu`t%OpenColorMenu%, %trayicon%,,34
if default4tray = 1
	menu, tray, default, Show Color Menu`t%OpenColorMenu%
; menu, tray, default, Settings && Info Window
gosub setmenu
menu, tray, add, ; line -------------------------
if default4tray = 3
	{
		menu, tray, add, Show Quick Settings Menu`t%ShowQCMsettingsmenu%, ShowQCMsettingsmenu
		menu, tray, icon, Show Quick Settings Menu`t%ShowQCMsettingsmenu%, %icons%\setting gear cog JLicons_40_64x64.ico
		menu, tray, default, Show Quick Settings Menu`t%ShowQCMsettingsmenu%
	}
else
	{
		menu, tray, add, Settings Menu >>>`t%ShowQCMsettingsmenu%, :ccs
		menu, tray, icon, Settings Menu >>>`t%ShowQCMsettingsmenu%, %icons%\setting gear cog JLicons_40_64x64.ico
	}
; menu, tray, default, Setting Menu >>>
menu, tray, add, Open Settings && Info Window`t%ShowHelpSettingWindow%, colormenuhelpgui
menu, tray, icon, Open Settings && Info Window`t%ShowHelpSettingWindow%, %icons%\about.ico
if default4tray = 4
	menu, tray, default, Open Settings && Info Window`t%ShowHelpSettingWindow%
menu, tray, add, Show QCM Toolbar`t%ShowQCMToolbar%,ShowQCMToolbar
menu, tray, icon, Show QCM Toolbar`t%ShowQCMToolbar%,%icons%\toolbar.ico
if default4tray = 2
	menu, tray, default, Show QCM Toolbar`t%ShowQCMToolbar%
menu, tray, add, ; line -------------------------
Menu, Tray, add, Reload App`t%ReloadQCM%, ReloadQCM
Menu, Tray, icon, Reload App`t%ReloadQCM%, %icons%\reload.ico
menu, tray, add, Quit \ Exit App`t%ExitQCM%, ExitQCM
menu, tray, icon, Quit \ Exit App`t%ExitQCM%, %icons%\exitapp.ico

; Menu, tray, default, Show Color Menu

Menu, Tray, Click, 2 ;makes left click on trayicon run default label on a single click, have to define defualt to the menu item
; Menu, Tray, Click, 2, ShowQCMToolbar

if (HideTrayIcon)
	Menu, Tray, NoIcon ;#NoTrayIcon
else
	Menu, tray, icon, %trayicon%


OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1. 
;;∙======∙Gui Drag Pt 2∙==========================================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}

If !pToken := Gdip_Startup() { ; Initialize GDI+ on start up
	tooltip, ERR! Failed to Start GDI+.`nInsert Color Menu might break.`n @ Line: %A_LineNumber% `n %A_LineFile%
	SetTimer, RemoveToolTip, -2000
} 

global ShowColorWindow := False

IsColorPickerWindow(hwnd := "") {
    if !hwnd
        hwnd := WinExist("A")
    WinGetClass, class, ahk_id %hwnd%
    if (class != "#32770")
        return false

    WinGet, controls, ControlList, ahk_id %hwnd%
    edits := 0
    Loop, Parse, controls, `n
    {
        if (SubStr(A_LoopField, 1, 4) = "Edit")
            edits++
    }

    return (edits = 6)
}


iniread, RunCount, %inifile%, QCMConfig, RunCount, 0
RunCount++ ; add 1 to the previously read #
iniwrite, %RunCount%, %inifile%, QCMConfig, RunCount
; iniread, ExitReason, %inifile%, QCMConfig, ExitReason

if (GUIVis)
	Gosub CChelp

if (ToolVis) || (ShowToolbarOnStartup)
	Gosub ShowQCMToolbar



Return
;; first return

 

BuildColorMenu:
;; SHARE
SetTitleMatchMode, 2
WinGetClass, class, class, A
WinGetTitle, title, A
global Tiles, ColorMenuTileSize, ColorPicker
global XColor := False

menu, cc, add
Menu, cc, DeleteAll  ; Clear existing menu before rebuilding
menu, ccb, add
menu, ccb, deleteall

IsPS := 0

iniread, ColorMenuTileSize, %inifile%, ColorMenuOptions, ColorMenuTileSize, 24
if (ColorMenuTileSize = "")
	ColorMenuTileSize := 24
	
;; these are for displaying on the menu
Iniread, OpenColorMenu, %inifile%, Global_Hotkeys, OpenColorMenu
Global OpenColorMenu

gosub setmenu

iniread, ShowBasicsSubMenu, %inifile%, ColorMenuOptions, ShowBasicsSubMenu, 1
global ShowBasicsSubMenu

; Read the default click action
IniRead, DefaultAction, %inifile%, ColorMenuOptions, DefaultClickAction, 1
global DefaultAction
; Set the checked variables for GUI
DefaultAction1 := (DefaultAction = 1) ? 1 : 0
DefaultAction2 := (DefaultAction = 2) ? 1 : 0
DefaultAction3 := (DefaultAction = 3) ? 1 : 0
DefaultAction4 := (DefaultAction = 4) ? 1 : 0


menu, cc, add, Quick Color Menu`t%OpenColorMenu%, OpenColorMenu
menu, cc, icon, Quick Color Menu`t%OpenColorMenu%, %Icons%\Icons_039_COLORWHEELCUT_256x256.ico,,32
menu, cc, default, Quick Color Menu`t%OpenColorMenu%
menu, cc, add, ; line -------------------------




menu, acc, add
menu, acc, deleteall
if IsColorPickerWindow()
	{
		menu, acc, add, Add From Color Window, addnewcolorcode
		menu, acc, default, Add From Color Window,
		menu, acc, icon, Add From Color Window, %Icons%\lc_insertpushbutton_24x24.ico,,24
		menu, acc, add, ; line -------------------------
	}

if WinActive("ahk_class PSFloatC ahk_exe photoshop.exe") ;; photoshop color window
{ 
	IsPS := 1
	menu, acc, add, Add From PS Color Window,  addnewcolorcode ; addPS 
	menu, acc, default, Add From PS Color Window,
	menu, acc, icon, Add From PS Color Window, %Icons%\lc_insertpushbutton_24x24.ico,,24
	menu, acc, add, ; line -------------------------
}
menu, acc, add, Add New Color, addnewcolorcode
menu, acc, icon, Add New Color, %Icons%\eyedropper.ico,,24

menu, acc, add, Add From Screen, AddNewColorFromScreen4menu
menu, acc, icon, Add From Screen, %icons%\mouse pointer click main_10_2_32x32.ico
; menu, acc, add, ; line -------------------------
if FileExist(ShareX)
	{
		menu, acc, add, ; line -------------------------
		menu, acc, add, Add via ShareX Color Picker, AddViaShareX
		menu, acc, icon, Add via ShareX Color Picker, %shareX%
	}

menu, acc, UseErrorLevel, on
if RegExMatch(Clipboard, "i)^[a-f0-9]{6}$", ncc)
{
	menu, acc, add, ; line -------------------------
    ; StringUpper, clipboard, clipboard
    GenerateColorIcon(clipboard)
    menu, acc, add, Add from Clipboard ( %clipboard% ), AddFromClip
    menu, acc, icon, Add from Clipboard ( %clipboard% ), %Tiles%\%clipboard%.png
    ; ncc := Match
}
if RegExMatch(Clipboard, "i)(?:rgb\s*\(\s*)?(\d{1,3})[\s,]+(\d{1,3})[\s,]+(\d{1,3})\s*\)?", rgbMatch)
{
    R := rgbMatch1
    G := rgbMatch2
    B := rgbMatch3

    if (R >= 0 && R <= 255 && G >= 0 && G <= 255 && B >= 0 && B <= 255)
    {
        hexColor := Format("{:02X}{:02X}{:02X}", R, G, B)
        GenerateColorIcon(hexColor)
		menu, acc, add, ; line -------------------------
        menu, acc, add, Add from Clipboard ( %clipboard% ), AddFromClip
        menu, acc, icon, Add from Clipboard ( %clipboard% ), %Tiles%\%hexColor%.png
    }
}

if FileExist(JustColorPicker)
	{
		; menu, acc, add, jcp icon, dummy
		; menu, acc, add, jpc icon, %justcolorpicker%
		; menu, acc, add, ; line -------------------------
		if !WinExist("Just Color Picker ahk_class TCustomForm")
			{
				menu, acc, add, Run Just Color Picker, RunJustColorPicker
				menu, acc, icon, Run Just Color Picker, %JustColorPicker%
			}
		else
			{
				ControlGetText, jcpCC, Edit1, Just Color Picker ahk_class TCustomForm,HiddenRadioButton
				if RegExMatch(jcpCC, "i)^[a-f0-9]{6}$", ncc)
				{
					menu, acc, add, ; line -------------------------
					; StringUpper, clipboard, clipboard
					GenerateColorIcon(jcpCC)
					menu, acc, add, Add from JCP ( %jcpCC% ), AddFromJCP
					menu, acc, icon, Add from JCP ( %jcpCC% ), %Tiles%\%jcpCC%.png
				}
				; else
				if (jcpCC = "")
				{
					menu, acc, add, ; line -------------------------
					menu, acc, add, JCP color field is empty, RunJustColorPicker
					menu, acc, icon, JCP color field is empty, %iconerror%
				}
			}
	}
if FileExist(ColorMania)
{
	if !WinExist("ahk_class TfrmColorPick")
	{
		menu, acc, add, Run ColorMania, RunColorMania
		menu, acc, icon, Run ColorMania, %colormania%
	}
	else	; if WinExist("ahk_class TfrmColorPick")
	{
		; winget, ColorManiaPath, ProcessPath, ahk_class TfrmColorPick
		ControlGetText, ColorManiaCC, TEdit1, ahk_class TfrmColorPick
		StringReplace, ColorManiaCC, ColorManiaCC, #, ,
		if RegExMatch(ColorManiaCC, "i)^[a-f0-9]{6}$", ncc)
			{
				menu, acc, add, ; line -------------------------
				GenerateColorIcon(ColorManiaCC)
				menu, acc, add, Add from ColorMania ( %ColorManiaCC% ), AddFromColorMania
				menu, acc, icon, Add from ColorMania ( %ColorManiaCC% ), %tiles%\%ColorManiaCC%.png
			}
	}
}
menu, acc, UseErrorLevel, off

if IsColorPickerWindow()
	{
		menu, cc, add, ! Color Picker Detected`tClick 🡳 2 Change It's Color, ShowColorMenu
		menu, cc, icon,  ! Color Picker Detected`tClick 🡳 2 Change It's Color, %icons%\attention.ico,,24
		menu, cc, add, ; line -------------------------
	}
if WinActive("ahk_class PSFloatC ahk_exe photoshop.exe") ;; photoshop color window
{ ;}
	menu, cc, add, ! PS Color Picker`tClick 🡳 2 Change It's Color, ShowColorMenu
	menu, cc, icon,  ! PS Color Picker`tClick 🡳 2 Change It's Color, %icons%\attention.ico,,24
	; ControlGetText, hexColor, edit7, A
	; StringUpper, hexColor, hexColor
	; if (hexColor != "")
	; {
		; GenerateColorIcon(hexColor)
		; menu, cc, add, %hexColor%, dummy
		; menu, cc, icon, %hexColor%, %tiles%\%hexColor%.png
	; }
	IsPS := 1
	menu, cc, add, ; line -------------------------
}
	colors := {}  ; Create an associative array to store colors

	IniRead, colorList, %inifile%, ColorMenuLayout  ; Read entire section
	colorcount := 0
	linecount := 0
	Loop, Parse, colorList, `n, `r 
	{
		if (A_LoopField = "")
			continue
			
		Colorcount++
		colorData := StrSplit(A_LoopField, "=")  ; Split key=value
		
		if (colorData[1] = "ColorMenuTileSize")  ; Ignore this specific key
			continue

		if (colorData.MaxIndex() < 2)  ; Skip invalid lines
			continue

		hexCC := Trim(colorData[1])
		rgbCC := Trim(colorData[2])
		
		if (colorData[1] = "line") 
			{
				Menu, cc, Add, ; line -------------------------  
				linecount++
				continue
			}

		colors[hexCC] := rgbCC  ; Store in array

		GenerateColorIcon(hexCC)  ; Generate the icon
		Menu, cc, Add, %hexCC%`t%rgbCC%, scc
		if FileExist(Tiles . hexCC ".png")
			Menu, cc, Icon, %hexCC%`t%rgbCC%, %Tiles%\%hexCC%.png,, %ColorMenuTileSize%
		else
			Menu, cc, Icon, %hexCC%`t%rgbCC%, %iconerror%,, %ColorMenuTileSize%
	
		
		; Menu, cc, Icon, %hexCC%`t%rgbCC%, %Tiles%%hexCC%.png,, %ColorMenuTileSize%
		colorcountsum := colorcount - linecount
	}
	
	menu, cc, add, ; line -------------------------
				
	if (ShowBasicsSubMenu)
		{
			
			Menu, ccb, Add
			menu, ccb, deleteall
			IniRead, colorList, %inifile%, BasicColorsSubmenu  ; Read entire section
			Loop, Parse, colorList, `n, `r 
			{
				if (A_LoopField = "")
					continue
					
				Colorcount++
				colorData := StrSplit(A_LoopField, "=")  ; Split key=value
				
				if (colorData[1] = "ColorMenuTileSize")  ; Ignore this specific key
					continue

				if (colorData.MaxIndex() < 2)  ; Skip invalid lines
					continue

				hexCC := Trim(colorData[1])
				rgbCC := Trim(colorData[2])
				
				if (colorData[1] = "line") 
					{
						Menu, ccb, Add, ; line -------------------------  
						linecount++
						continue
					}

				colors[hexCC] := rgbCC  ; Store in array

				GenerateColorIcon(hexCC)  ; Generate the icon
				Menu, ccb, Add, %hexCC%`t%rgbCC%, scc
				if FileExist(Tiles . hexCC ".png")
					Menu, ccb, Icon, %hexCC%`t%rgbCC%, %Tiles%\%hexCC%.png,, %ColorMenuTileSize%
				; if FileExist(hexcc)
					; Menu, ccb, Icon, %hexCC%`t%rgbCC%, %Tiles%\%hexCC%.png,, %ColorMenuTileSize%
				; else
					; Menu, ccb, Icon, %hexCC%`t%rgbCC%, %iconerror%,, %ColorMenuTileSize%
			}
			
				
				
			Menu, cc, add, Basics >>, :ccb
			Menu, cc, icon, Basics >>, %icons%\color wheel applications-graphics_96x96.ico
		; if (showhtml16menu)
			; {
				; gosub buildHtml16Menu
				; menu, ccb, add, ; line -------------------------
				; menu, ccb, add, Html Colors, :h16
				; menu, ccb, icon, Html Colors, %icons%\file_extension_html__32x32.ico
			; }
		}
	if (ShowAlphaSubMenu)
		{
			gosub hexalpha5ths ;hexpercentFULL
			menu, cc, add, Alpha ## >>, :ha
			menu, cc, icon, Alpha ## >>, %icons%\rgb alpha transp 64.ico
		}
	menu, cc, add, ; line -------------------------
	Menu, cc, add, + Add Color >`t%ShowAddColorMenu%, :acc
	Menu, cc, icon, + Add Color >`t%ShowAddColorMenu%, %Icons%\eyedropper.ico
	menu, cc, add, ; line -------------------------
	menu, cc, add, HEX# Count: %colorcountsum%`tTile Size: %ColorMenuTileSize%px, :ccs
	; menu, cc, add, HEX# Count: %colorcountsum%`tTile Size: %ColorMenuTileSize%px, colormenuhelpgui
	menu, cc, icon, HEX# Count: %colorcountsum%`tTile Size: %ColorMenuTileSize%px, %icons%\setting gear cog JLicons_40_64x64.ico,,%ColorMenuTileSize%
	menu, cc, add, Show QCM Toolbar`t%ShowQCMToolbar%,ShowQCMToolbar
	menu, cc, icon, Show QCM Toolbar`t%ShowQCMToolbar%,%icons%\toolbar.ico,,24
	if FileExist(ColorPicker1)
		{
			menu, cc, add, ; line -------------------------
			menu, cc, add, Run Color Picker, RunColorPicker1
			menu, cc, icon, Run Color Picker, %colorpicker1% ;%Icons%\just color picker icon crosshairs 16x16.ico ;"
		}
	if WinActive("HEX # ahk_class AutoHotkeyGUI")
		{
			global ShowColorWindow := True
			menu, cc, add, ; line -------------------------
			menu, cc, add, Close Color Window, CloseColorWindowX ; CloseAllColorGUIs ;  CloseColorWindowX
			menu, cc, icon, Close Color Window, %Icons%\aero Close_24x24-32b.ico
			menu, cc, add, Close *ALL* Color Windows, CloseAllColorGUIs ; CloseAllColorGUIs ;  CloseColorWindowX
			menu, cc, icon, Close *ALL* Color Windows, %Icons%\aero Close_24x24-32b.ico
		}
		

if (A_Username = "CLOUDEN")
{
	;; Ignore 4 Share
	if (A_IsCompiled)
	{
	menu, cc, add, ; line -------------------------	;; Ignore 4 Share
	menu, cc, Add, !!! DEV EXE !!!, DUMMY	;; Ignore 4 Share
	menu, cc, ICON, !!! DEV EXE !!!, %ICONERROR%,,32	;; Ignore 4 Share
	}
	else
	{
	menu, cc, add, ; line -------------------------	;; Ignore 4 Share
	menu, cc, Add, !!! DEV AHK !!!, DUMMY	;; Ignore 4 Share
	menu, cc, ICON, !!! DEV AHK !!!, %ICONERROR%,,32	;; Ignore 4 Share
	}
	menu, ahk, Standard
}

return



;---------------------------------------------------------------------------
AddNewColorFromScreen:
SetTimer, AddNewColorFromScreenDelayed, -1000
return

AddNewColorFromScreenDelayed:
AddNewColorFromScreen4menu:
SetTimer, getmousecolor, 50
SetTimer, checkMouseClick, 20
return

getmousecolor:
ncc := ""
mclr := ""
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen  ; Ensure PixelGetColor aligns with screen coordinates
MouseGetPos, msX, msY
PixelGetColor, mClr, msX, msY, RGB

mClr := SubStr(mClr, 3)  ; Remove the "0x" prefix
Red := SubStr(mClr, 1, 2)
Green := SubStr(mClr, 3, 2)
Blue := SubStr(mClr, 5, 2)

Tooltip, HEX#: %mClr%`n`nPress:`nCtrl  or  Click to Add Color to Menu`nESC  or  Right Click = Cancel
return

checkMouseClick:
    if (GetKeyState("LButton", "P")) {  ; Left click detected
        SetTimer, checkMouseClick, Off
        SetTimer, getmousecolor, Off
        Tooltip  ; Clear tooltip
        ; MsgBox, Color Added: #%mClr%
		ncc := mclr
		; MsgBox mclr#: %mclr%`n`nncc: %ncc%
		if (XColor)
			goto AddXColor
		goto AddColorToINI
        return
    }
	if (GetKeyState("Control", "P")) {  ; control tab to add color
		SetTimer, checkMouseClick, Off
		SetTimer, getmousecolor, Off
		Tooltip  ; Clear tooltip
		; MsgBox, Color Added: #%mClr%
		ncc := mclr
		; MsgBox mclr#: %mclr%`n`nncc: %ncc%
		if (XColor)
			goto AddXColor
		goto AddColorToINI
		return
	}
    if (GetKeyState("RButton", "P")) {  ; Right click detected
        SetTimer, checkMouseClick, Off
        SetTimer, getmousecolor, Off
        Tooltip  ; Clear tooltip
		XColor := False
        return
    }
	If (GetKeyState("ESC", "P")) {
        SetTimer, checkMouseClick, Off
        SetTimer, getmousecolor, Off
        Tooltip  ; Clear tooltip
		XColor := False
        return
	
	}
return

addPS:

ControlGetText, hexColor, edit7, ahk_class PSFloatC ahk_exe photoshop.exe
; tooltip in if Ps Add++`n`nhexcolor: %hexcolor%

ncc := hexColor
if !RegExMatch(HexColor, "i)^[a-f0-9]{6}$", match) 
	{
		tooltip, ERR! Could not match a`nHEX Code from this window.
		SetTimer, RemoveToolTip, -2500
		return
	}

goto AddColorToINI

return
;---------------------------------------------------------------------------

;; new addnewcolorcode from claude that also matches RGB formats
addnewcolorcode:
SetTitleMatchMode, 2
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
    {
        XColor := True ; if (XColor)
    }
else If (GetKeyState("Control", "P"))
    {
        goto ChangeColorTileSize
    }
ncc := ""
jcpcc := ""

; Handle Windows color dialog

if IsColorPickerWindow()
{
    Sleep 200
    WinActivate ;Color ahk_class #32770

	; ControlGetText, R, edit4, Color ahk_class #32770
	; ControlGetText, G, edit5, Color ahk_class #32770
	; ControlGetText, B, edit6, Color ahk_class #32770
	;; had to change these to A active window, if the color has a lower case c won't see it.
	ControlGetText, R, edit4, A
	ControlGetText, G, edit5, A
	ControlGetText, B, edit6, A
	
    hexColor := Format("{:02X}{:02X}{:02X}", R, G, B)
    ncc := hexColor
	
	if !RegExMatch(HexColor, "i)^[a-f0-9]{6}$", match) 
		{
			tooltip, ERR! Could not match a`nHEX Code from this window.
			SetTimer, RemoveToolTip, -2500
			return
		}
	if (XColor)
		GoTo AddXColor
	goto AddColorToINI
}
; if WinActive("ahk_class PSFloatC ahk_exe photoshop.exe") ;; photoshop color window
if (IsPS)
{
	ControlGetText, hexColor, edit7, ahk_class PSFloatC ahk_exe photoshop.exe
	; tooltip in PF Add++`n`nhexcolor: %hexcolor%
	ncc := hexColor
	if !RegExMatch(HexColor, "i)^[a-f0-9]{6}$", match) 
		{
			tooltip, ERR! Could not match a`nHEX Code from this window.
			SetTimer, RemoveToolTip, -2500
			return
		}
	if (XColor)
		GoTo AddXColor
	goto AddColorToINI
} 


; Check clipboard for hex color
if RegExMatch(Clipboard, "i)^[a-f0-9]{6}$", match) 
{
    ncc := match
    Tooltip, Clipboard contains: %ncc%`n`nIt Has automatically been Added to the menu.
    SetTimer, RemoveToolTip, -3000
    if (XColor)
        GoTo AddXColor
    Goto AddColorToINI
}

; Check clipboard for RGB format and convert to HEX
; Match formats like: rgb(255, 255, 255) or 255, 255, 255 or 255,255,255
if RegExMatch(Clipboard, "i)(?:rgb\s*\(\s*)?(\d{1,3})[\s,]+(\d{1,3})[\s,]+(\d{1,3})\s*\)?", rgbMatch) 
{
    R := rgbMatch1
    G := rgbMatch2
    B := rgbMatch3
    
    ; Validate RGB values are in range 0-255
    if (R >= 0 && R <= 255 && G >= 0 && G <= 255 && B >= 0 && B <= 255) {
        hexColor := Format("{:02X}{:02X}{:02X}", R, G, B)
        ncc := hexColor
        ToolTip, Converted RGB(%R%`,%G%`,%B%) to HEX: %ncc%`n`nIt Has automatically been Added to the menu.
        SetTimer, RemoveToolTip, -3000
        if (XColor)
            GoTo AddXColor
        Goto AddColorToINI
    }
}

; Just Color Picker integration
if WinExist("Just Color Picker ahk_class TCustomForm")
    {
        ControlGetText, jcpCC, Edit1, Just Color Picker ahk_class TCustomForm,HiddenRadioButton
    }

; Ask for input if no color was automatically detected
InputBox, ncc, ECLM - Add A New Color Code, Adding a item the Insert Color Menu.`n`nEnter a 6-digit HEX Code `(`0`-`9`, `A`-`F`)`nE.g.. FFB900 or 2a82da`nOr a RGB Number Code`nE.g.. 46`, 85`, 245 or 255`, 125`, 175`n`nOther formats won't be converted.`n`n** If your Clipboard contains a HEX-Code or RGB values when you click this menu item it will skip this input box and add it automatically!,,380,380,,,,,%jcpcc%
if (ncc = "") || (ErrorLevel)
    return

; Check if the input is a HEX color
if RegExMatch(ncc, "i)^[A-Fa-f0-9]{6}$") 
{
    if (XColor)
        GoTo AddXColor
    goto AddColorToINI
}
; Check if the input is an RGB color 
else if RegExMatch(ncc, "i)(?:rgb\s*\(\s*)?(\d{1,3})[\s,]+(\d{1,3})[\s,]+(\d{1,3})\s*\)?", rgbMatch)
{
    R := rgbMatch1
    G := rgbMatch2
    B := rgbMatch3
    
    ; Validate RGB values are in range 0-255
    if (R >= 0 && R <= 255 && G >= 0 && G <= 255 && B >= 0 && B <= 255) {
        ncc := Format("{:02X}{:02X}{:02X}", R, G, B)
        if (XColor)
            GoTo AddXColor
        goto AddColorToINI
    }
    else {
        Tooltip Invalid RGB values! Values must be between 0-255.
        SetTimer, RemoveToolTip, -2500
        Goto addnewcolorcode
    }
}
else
{
    Tooltip Invalid color format! Use HEX (6 characters 0-9`, A-F) or RGB format (r`,g`,b).
    SetTimer, RemoveToolTip, -2500
    Goto addnewcolorcode
}
return

AddFromColorMania:
ncc := ColorManiaCC
goto AddColorToINI
AddFromJCP:
ncc := jcpCC
goto AddColorToINI
AddFromClip:
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
    {
        XColor := True ; if (XColor)
    }
    ncc := Clipboard
    
    ; Check if clipboard contains RGB format
    if RegExMatch(Clipboard, "i)(?:rgb\s*\(\s*)?(\d{1,3})[\s,]+(\d{1,3})[\s,]+(\d{1,3})\s*\)?", rgbMatch) 
    {
        R := rgbMatch1
        G := rgbMatch2
        B := rgbMatch3
        
        ; Validate RGB values are in range 0-255
        if (R >= 0 && R <= 255 && G >= 0 && G <= 255 && B >= 0 && B <= 255) {
            ncc := Format("{:02X}{:02X}{:02X}", R, G, B)
        }
    }
    
    if (XColor)
        GoTo AddXColor
    goto AddColorToINI
return

AddColorToINI:
StringUpper, ncc, ncc
rgb := HexToRGB(ncc)
if (RGB = "Invalid HEX")
	{
		tooltip, Err! Converting this HEX Code.`n @ Line: %A_LineNumber%
		SetTimer, RemoveToolTip, -3000
		return
	}
IniWrite, %rgb%, %inifile%, ColorMenuLayout, %ncc%  ; Store the HEX as a key with RGB as the value
Tooltip, Added... %ncc% = %rgb% ...to Color Menu.
SetTimer, RemoveToolTip, -3000
sleep 800
; jcpcc := ""
return
AddViaShareX:
run, %sharex%  -ScreenColorPicker
SetTimer, WatchShareX, 20
tooltip Watching ShareX...`nAfter Clicking to capture a color with ShareX QCM will `nGet the Color Code From your Clipboard.`nPress ESC to CANCEL.
SetTimer, RemoveToolTip, -3000
return
WatchShareX:
if (GetKeyState("LButton", "P")) {  ; Left click detected
        SetTimer, WatchShareX, Off
        SetTimer, getmousecolor, Off
		sleep 500 ;; let ShareX update the clipboard
		ncc := Clipboard
		goto AddFromClip
    }
	If (GetKeyState("ESC", "P")) {
        SetTimer, WatchShareX, Off
        SetTimer, getmousecolor, Off
        Tooltip  ; Clear tooltip
		XColor := False
        return
	}
return
AddXColor:
if (XColor)
{
if !FileExist(XColorFile)
	Return
StringUpper, ncc, ncc
; rgb := HexToRGB4AHK(ncc)
rgb := HexToRGB(ncc)
if (RGB = "Invalid HEX")
	{
		tooltip, Err! Converting this HEX Code.`n @ Line: %A_LineNumber%
		SetTimer, RemoveToolTip, -300
		return
	}
NewCCXMenuItem = 
(
GenerateColorIcon("%ncc%")
Menu, ccx, Add, %ncc%``t%rgb%, scc
Menu, ccx, Icon, %ncc%``t%rgb%, `%Tiles`%\%ncc%.png,,`%ColorMenuTileSize`%
)
FileAppend,`n`n%NewCCXMenuItem%`n,%XColorFile%,utf-8
sleep 300
tooltip New xXx Color Menu Item Added.
SetTimer, RemoveToolTip, -2000
XColor := False
Return
}
return

HexToRGB(hexColor)
{
    if !RegExMatch(hexColor, "^[A-Fa-f0-9]{6}$") ; Ensure it's a valid 6-character hex
        return "Invalid HEX"

    r := "0x" . SubStr(hexColor, 1, 2)  ; Extract red
    g := "0x" . SubStr(hexColor, 3, 2)  ; Extract green
    b := "0x" . SubStr(hexColor, 5, 2)  ; Extract blue
	
	if (XColor)
		return Format("{}``, {}``, {}", r+0, g+0, b+0)  ; Convert to decimal and format & add escape chars ` for saving in an .ahk file
	else
		return Format("{}, {}, {}", r+0, g+0, b+0)  ; Convert to decimal and format
}


;---------------------------------------------------------------------------



;---------------------------------------------------------------------------
ShowColorMenu:
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
	{
		gosub EditINI
		return
	}
if (GetKeyState("Lwin", "P") && GetKeyState("Control", "P")) 
	{
		; keywait Control
		; keywait Lwin
		gosub editini
		return
	}
if (GetKeyState("Lwin", "P") && GetKeyState("Shift", "P")) ;; ignore 4 share
	{
		tooltip, Not assigned yet...`n%a_linefile%`n @ Line: %A_linenumber%
		SetTimer, RemoveToolTip, -2000  
		return
	}
if (GetKeyState("Control", "P"))
	{
		; keywait Control
		gosub ChangeColorTileSize
		return
	}
if (GetKeyState("Shift", "P"))
	{
		; keywait Shift
		tooltip, Not assigned yet...`n%a_linefile%`n @ Line: %A_linenumber%
		SetTimer, RemoveToolTip, -2000 
		return
	}
else ;; normal click
	{
		gosub BuildColorMenu
		menu, cc, show
	}
return
OpenColorMenu:
OpenColorMenu2:
OpenColorMenu3:
gosub BuildColorMenu
menu, cc, show
return
;--------------------------------------------------------------------------- FFB900	255, 185, 0

sendhtml16:
tooltip, This Menu is a list of the 16 named colors used in HTML coding.`nIt's still under development. For now its just here for reference.
SetTimer, RemoveToolTip, -5500
return

sendhtml16_BLOCK:
; selected := ""
;-------------------------
	; keywait, Control
	selected := A_ThisMenuItem
	parts := StrSplit(selected, "`t")  ; Split at `t Blue Fuchsia 
	colorname := Trim(parts[1])
if GetKeyState("Control", "P")
{
	keywait, Control
	sleep 200
	Sendraw %colorname%
	return
}
else
{
	selected := parts[2]
	StringReplace, selected, selected, -, `t, All
	; selected := Strsplit(selected, "`t")
	; global HexCC := Trim(selected[1])
	; global rgbCC := Trim(selected[2])  ; The RGB values
	; StringReplace, rgbCC, rgbCC, 000, 0, All
	goto skipsccsplit
}
return

sendcolorcode:
; copyalpha:
scc:
selected := A_ThisMenuItem
skipsccsplit:
parts := StrSplit(selected, "`t")  ; Split at `t

hexCC := parts[1]  ; The HEX code
rgbCC := parts[2]  ; The RGB values
StringReplace, rgbCC, rgbCC, 000, 0, All
; tooltip TMI:%A_thismenuItem%`nSEL:%selected%`nName:%name%`nHexcc:%HexCC%`nrgbcc:%rgbcc%
if (ShowColorWindow)
	{
		goto ShowColorGUIX
	}
; Check for modifier keys first (these override the default action)
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P") && GetKeyState("Lwin", "P"))
	{
		goto ShowColorGUIX
		; ShowColorWindow := True
	}
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))  ; Copy RGB
	{

		clipboard := "" 
		sleep 50
		clipboard := rgbCC
		clipwait,0.5
		If (clipboard != "")
			{
				Tooltip Copied: %rgbCC%
				SetTimer, RemoveToolTip, -1500
			}
		return 
	}
if (GetKeyState("Lwin", "P") && GetKeyState("Control", "P"))
    {
        Tooltip Not assigned yet... @ Line: %A_LineNumber%
        SetTimer, RemoveToolTip, -1500
        return 
    }
if (GetKeyState("Lwin", "P") && GetKeyState("Shift", "P"))  ; Delete color from INI
    {
        IniDelete, %inifile%, ColorMenuLayout, %hexCC%
        Tooltip, Removed color: %hexCC%
        SetTimer, RemoveToolTip, -3000
        gosub BuildColorMenu
        return
    }
if (GetKeyState("Control", "P"))  ; Send RGB
    {
        sendraw, %rgbCC%
        return
    }
if (GetKeyState("Shift", "P"))  ; Copy HEX
    {
        clipboard := ""
        sleep 50
        clipboard := hexCC
        clipwait,0.5
        If (clipboard != "")
            {
                Tooltip Copied: %hexCC%
                SetTimer, RemoveToolTip, -1500
            }
        return
    }
if (GetKeyState("Lwin", "P"))  ; Show Color GUI
    {
        Color := hexCC
        goto ShowColorGUIX
    }
else  ; No modifiers - use default action from INI
    {
        ; Read the default action from INI file 
        ; IniRead, DefaultAction, %inifile%, Settings, DefaultClickAction, 1
        ; If in Color dialog, always insert the color
        
		if IsColorPickerWindow()
        {
			sleep 150 ; 300
			WinActivate  ;Color ahk_class #32770
            goto SendThisItemToTheColorWindow
        }
		if (IsPS)
		{
			sleep 150 ; 300
			WinActivate ahk_class PSFloatC ahk_exe photoshop.exe
			goto SendThisItemToPhotoshopColorWindow
		}
        else
        {
            ; Execute the appropriate default action 
            if (DefaultAction = 1)  ; Send HEX
            {
                sendraw, %hexCC%
            }
            else if (DefaultAction = 2)  ; Copy HEX
            {
                clipboard := ""
                sleep 50
                clipboard := hexCC
                clipwait,0.5
                If (clipboard != "")
                {
                    Tooltip Copied: %hexCC%
                    SetTimer, RemoveToolTip, -1500
                }
            }
            else if (DefaultAction = 3)  ; Send RGB
            {
                sendraw, %rgbCC%
            }
            else if (DefaultAction = 4)  ; Copy RGB
            {
                clipboard := ""
                sleep 50
                clipboard := rgbCC
                clipwait,0.5
                If (clipboard != "")
                {
                    Tooltip Copied: %rgbCC%
                    SetTimer, RemoveToolTip, -1500
                }
            }
        }
    }
; tooltip %A_thismenuItem%`n%name%`n%HexCC%`n%rgbcc%
return



;---------------------------------------------------------------------------
SendThisItemToPhotoshopColorWindow:
SetTitleMatchMode, 2
sleep 50
WinActivate ahk_class PSFloatC ahk_exe photoshop.exe
sleep 150
ControlFocus, Edit7, ahk_class PSFloatC ahk_exe photoshop.exe
sleep 300
ControlFocus, Edit7, ahk_class PSFloatC ahk_exe photoshop.exe
; sendinput, {backspace}
send, ^a
sleep 150
send, ^a
sleep 50
; ControlSetText, Edit7, %hexCC%, ahk_class PSFloatC ahk_exe photoshop.exe
; sleep 100
SendInput {Raw}%hexCC%
; sleep 250
; sendinput {tab}
return
SendThisItemToTheColorWindow:
sleep 200
WinActivate Color ahk_class #32770
rgb_array := StrSplit(rgbcc, ",")
R := rgb_array[1]
G := rgb_array[2]
B := rgb_array[3]
; MsgBox %rgbcc%`n`nr %r%`n`ng%g%`n`nb%b%
ControlFocus Edit3
SendInput {Raw}`t%R%`t%G%`t%B%  ;; should there be another tab here ?? hmm #todo
return

;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
CChelp:
ShowHelpSettingWindow:
colormenuhelpgui:
iniwrite, 1, %inifile%, QCMConfig, GUIVis

if !(DarkMode)
	Goto colormenuhelpguiLIGHT

gui, cch: destroy
gui, cch: new
gui, cch: Font, s10 cSilver, Consolas
gui, cch: Color, c202124,c252D13
gui, cch: margin, 10,10


gui, cch: add, picture,  w32 h32 hwndhsm gOpenColorMenu XM, %Icons%\Icons_039_COLORWHEELCUT_256x256.ico
AddTooltip(hsm, "Show Quick Color Menu")

gui, cch: add, Picture, hwndhanc w32 h32 gShowAddColorMenu x+m, %icons%\eyedropper.ico
AddTooltip(hanc, "Show Add New Color Menu")


gui, cch: add, Picture, hwndhTB w32 h32 gSwitch2QCMToolbar x+m, %icons%\toolbar.ico
addtooltip(hTB, "Switch to QCM Toolbar")

gui, cch: add, text, x+m , %a_tab%

gui, cch: add, Picture, hwndhssm w32 h32 gShowQCMsettingsmenu x+m, %icons%\setting gear cog JLicons_40_64x64.ico
AddTooltip(hssm, "Show Quick Settings Menu`n`nThere are few more settings not in the window below.")

gui, cch: Add, picture, hwndheini w32 h32 gEditINI x+m, %icons%\settingsaltini.ico
addtooltip(heini, "Editing the -SETTINGS.ini File")

gui, cch: Add, Text, x+m, %a_TAB% 
gui, cch: Add, Text, x+m, %a_TAB% 

gui, cch: Add, picture, hwndhrebut w32 h32 gReloadQCM x+m, %icons%\Reload.ico
AddTooltip(hrebut, "Reload App")

Gui, cch: Add, Button, vcw gcchclose x+m, Close Window
GuiControlGet, hwndcw, Hwnd, cw
DllCall("uxtheme\SetWindowTheme", "ptr", hwndcw, "str", "DarkMode_Explorer", "ptr", 0)

; gui, cch: Add, Button, x+m gcchclose, Close Window
gui, cch: add, picture, hwndhexa x+m w32 h32 gExitQCMviaGUI, %icons%\exitapp.ico
AddTooltip(hexa, "Quit \ Exit App")


;-------------------------------------------------- start tabs layout

gui, cch: font, cFFB900
gui, cch: add, GroupBox, x20 y60 w300 h285 , [ ? What's QCM ? ]
gui, cch: font, cSilver
gui, cch: add, text, xp+10 yp+20 w280 h260,  Quick Color Menu is Context menu for Saving, Storing && Pasting Color Code Snippets into text editors. It can handle output and input from HEX && RGB formats, without prefixes.`n`nIts not a color picker replacement, it can launch one for you, rather a convenient place save a color list that you can call quickly, with a hotkey, and paste with one click.`n`n** It has an added bonus of being able to Change the color in Windows Standard Color Picker Dialog Boxes with one click! **

gui, cch: font, cFFB900
gui, cch:  add, GroupBox, x20 y346 w300 h160  , [ Default Click Action ]
gui, cch: font, cSilver
gui, cch:  add, Radio, xp+10 yp+20 section vDefaultClickAction Checked%DefaultAction1%, Paste HEX code
gui, cch:  Add, Radio, xs Checked%DefaultAction2%, Copy HEX code to clipboard
gui, cch:  Add, Radio, xs Checked%DefaultAction3%, Paste RGB values
gui, cch:  Add, Radio, xs Checked%DefaultAction4%, Copy RGB values to clipboard
Gui, cch: Add, Button, vsca gSaveDefaultClickAction xs, Save Click Action
GuiControlGet, hwndsca, Hwnd, sca
DllCall("uxtheme\SetWindowTheme", "ptr", hwndsca, "str", "DarkMode_Explorer", "ptr", 0)
gui, cch: font, cFFB900
gui, cch: add, GroupBox, x20 y508 w300 h150  , [ Global_Hotkeys * ]
gui, cch: font, cSilver
IniRead, CurrentOpenColorMenu, %inifile%, Global_Hotkeys, OpenColorMenu

global CurrentColorMenuHotkey := CurrentOpenColorMenu

WINKEYSTATE := 0
HotkeyWithoutWin := CurrentOpenColorMenu
if InStr(CurrentOpenColorMenu, "#") {
    WINKEYSTATE := 1
    HotkeyWithoutWin := StrReplace(CurrentOpenColorMenu, "#", "")
}

gui, cch: add, Text, xp+10 yp+20 section w280 wrap hwndhmorekeys gdummy , Show Quick Color Menu * ; There are more hotkeys you can add the settings file.
AddTooltip(hmorekeys, "* There are more hotkeys you can`nadd in the settings file.`nThis key is to show the main menu.")

gui, cch: add, Hotkey, xs w280 vNewOpenColorMenu, %HotkeyWithoutWin%
Gui, cch: Add, CheckBox, xs hwndhwkey gdummy vWINKEY Checked%WINKEYSTATE%, Win ⊞
addtooltip(hwkey, "Adds the ⊞ Windows Key to your hotkey")
Gui, cch: Add, Button, vshk gSaveOpenMenuHK xs, Save Hotkey
GuiControlGet, hwndshk, Hwnd, shk
DllCall("uxtheme\SetWindowTheme", "ptr", hwndshk, "str", "DarkMode_Explorer", "ptr", 0)
gui, cch: font, cFFB900
gui, cch: add, GroupBox, x20 y660 w300 h80  , [ Colors Tile Size ]
gui, cch: font, cSilver
iniread, ColorMenuTileSize, %inifile%, ColorMenuOptions, ColorMenuTileSize
gui, cch: add, edit, xp+10 yp+20 w50 section vnewtilesize Number, %ColorMenuTileSize%
gui, cch: add, text, x+p, %a_space%%a_space%pixels
Gui, cch: Add, Button, vsntbut gSaveNewTileSize x+10, Save Tile Size ; gChangeColorTileSize  g SaveNewTileSize
GuiControlGet, hwndsntbut, Hwnd, sntbut
DllCall("uxtheme\SetWindowTheme", "ptr", hwndsntbut, "str", "DarkMode_Explorer", "ptr", 0)
gui, cch: add, text, xs w280 wrap, Enter a pixel size between 16 and 72.



gui, cch: font, cFFB900
gui, cch: add, GroupBox, x325 y60 w300 h555 section , [ Color Menu Layout ]
gui, cch: font, cSilver

global LayoutSection := ""
global LayoutEdit 
global allowsave

iniread, LayoutSection, %inifile%, ColorMenuLayout
GuiControl,, LayoutEdit, %LayoutSection%

gui, cch: add, Edit, xp+10 yp+20 w280 r30 gQCMOnChange vLayoutEdit, %LayoutSection%
Gui, cch: Add, Button, disabled vallowsave gSaveLayOut h12 , Save Layout
GuiControlGet, hwndallowsave , Hwnd, allowsave
DllCall("uxtheme\SetWindowTheme", "ptr", hwndallowsave , "str", "DarkMode_Explorer", "ptr", 0)
	gui, cch: add, picture, w24 h24 x+15+p hwndhlay gdummy, %icons%\about.ico
	AddTooltip(hlay, "You can change the layout order`nof the colors in your menu in the box above`nor directly in the -settings.ini file.`n`nCut & paste to rearrange them & then save.`nAdd a Separator with * line= * between colors.")
gui, cch: Add, picture, w24 h24 x+15+p hwndhupdini gRefreshNewINI, %icons%\view-refresh xfav_32x32.ico
addtooltip(Hupdini, "Refresh Menu Layout`n`nRe-Reads from the INI if you added`ncolors while this window was open.")
gui, cch: font, cFFB900
gui, cch: add, GroupBox, x325 y625 w300 h115 , [ * ! NOTE ! * ]
gui, cch: font, cSilver s09, Consolas
gui, cch: add, Text, xp+10 yp+20 w280 section, Most of the settings in this window update live! These are just a few options affecting the main menu. And there are **more** options you can change in the -SETTINGS.ini file. You should manually reload QCM after making changes there.

;--------------------------------------------------
gui, cch: Font
gui, cch: Font, s10 cSilver, Consolas
; gui, cch: +AlwaysOnTop
if (Xg)
	gui, cch: Show, x%Xg% y%Yg%, ?? Quick Color Menu Settings && Info
else 
	gui, cch: Show, autosize , ?? Quick Color Menu Settings && Info
if (S2GUI)
	{
		gui, cch: +AlwaysOnTop
		SetTimer, relaseguipin, 500
	}
GUIVis := 1
Return
;***************************************************************************
;***************************************************************************
;***************************************************************************
colormenuhelpguiLIGHT: ; light mode lightmode 

gui, cch: destroy
gui, cch: new
gui, cch: Font, s10,  Consolas
; gui, cch: Color, c202124,c252D13 ; darkmode colors
gui, cch: Color, cE9E9E9
gui, cch: margin, 10,10

; gui, cch: Add, Text, gOpenColorMenu xm section, Show Menu 🡲
gui, cch: add, picture,  w32 h32 hwndhsm gOpenColorMenu XM, %Icons%\Icons_039_COLORWHEELCUT_256x256.ico
AddTooltip(hsm, "Show Quick Color Menu")

gui, cch: add, Picture, hwndhanc w32 h32 gShowAddColorMenu x+m, %icons%\eyedropper.ico
AddTooltip(hanc, "Show Add New Color Menu")
gui, cch: add, Picture, hwndhTB w32 h32 gSwitch2QCMToolbar x+m, %icons%\toolbar.ico
addtooltip(hTB, "Switch to QCM Toolbar")

gui, cch: add, text, x+m , %a_tab%

gui, cch: add, Picture, hwndhssm w32 h32 gShowQCMsettingsmenu x+m, %icons%\setting gear cog JLicons_40_64x64.ico
AddTooltip(hssm, "Show Quick Settings Menu`n`nThere are few more settings not in the window below.")

gui, cch: Add, picture, hwndheini w32 h32 gEditINI x+m, %icons%\settingsaltini.ico
addtooltip(heini, "Editing the -SETTINGS.ini File")

gui, cch: Add, Text, x+m, %a_TAB% 
gui, cch: Add, Text, x+m, %a_TAB% 

gui, cch: Add, picture, hwndhrebut w32 h32 gReloadQCM x+m, %icons%\Reload.ico
AddTooltip(hrebut, "Reload App")

Gui, cch: Add, Button, vcw gcchclose x+m, Close Window

gui, cch: add, picture, hwndhexa x+m w32 h32 gExitQCMviaGUI, %icons%\exitapp.ico
AddTooltip(hexa, "Quit \ Exit App")


;-------------------------------------------------- start tabs layout


gui, cch: font, c4B0082, Consolas
gui, cch: add, GroupBox, x20 y60 w300 h285 , [ ? What's QCM ? ]
gui, cch: font, c000000, Consolas
gui, cch: add, text, xp+10 yp+20 w280 h260,  Quick Color Menu is Context menu for Saving, Storing && Pasting Color Code Snippets into text editors. It can handle output and input from HEX && RGB formats, without prefixes.`n`nIts not a color picker replacement, it can launch one for you, rather a convenient place save a color list that you can call quickly, with a hotkey, and paste with one click.`n`n** It has an added bonus of being able to Change the color in Windows Standard Color Picker Dialog Boxes with one click! **

gui, cch: font, c4B0082, Consolas
gui, cch:  add, GroupBox, x20 y346 w300 h160  , [ Default Click Action ]
gui, cch: font, c000000, Consolas
gui, cch:  add, Radio, xp+10 yp+20 section vDefaultClickAction Checked%DefaultAction1%, Paste HEX code
gui, cch:  Add, Radio, xs Checked%DefaultAction2%, Copy HEX code to clipboard
gui, cch:  Add, Radio, xs Checked%DefaultAction3%, Paste RGB values
gui, cch:  Add, Radio, xs Checked%DefaultAction4%, Copy RGB values to clipboard
Gui, cch: Add, Button, vsca gSaveDefaultClickAction xs, Save Click Action
; GuiControlGet, hwndsca, Hwnd, sca
; DllCall("uxtheme\SetWindowTheme", "ptr", hwndsca, "str", "DarkMode_Explorer", "ptr", 0)
gui, cch: font, c4B0082, Consolas
gui, cch: add, GroupBox, x20 y508 w300 h150  , [ Global_Hotkeys * ]
gui, cch: font, c000000, Consolas
IniRead, CurrentOpenColorMenu, %inifile%, Global_Hotkeys, OpenColorMenu

global CurrentColorMenuHotkey := CurrentOpenColorMenu

WINKEYSTATE := 0
HotkeyWithoutWin := CurrentOpenColorMenu
if InStr(CurrentOpenColorMenu, "#") {
    WINKEYSTATE := 1
    HotkeyWithoutWin := StrReplace(CurrentOpenColorMenu, "#", "")
}

gui, cch: add, Text, xp+10 yp+20 section w280 wrap hwndhmorekeys gdummy , Show Quick Color Menu * ; There are more hotkeys you can add the settings file.
AddTooltip(hmorekeys, "* There are more hotkeys you can`nadd in the settings file.`nThis key is to show the main menu.")

gui, cch: add, Hotkey, xs w280 vNewOpenColorMenu, %HotkeyWithoutWin%
Gui, cch: Add, CheckBox, xs hwndhwkey gdummy vWINKEY Checked%WINKEYSTATE%, Win ⊞
addtooltip(hwkey, "Adds the ⊞ Windows Key to your hotkey")
Gui, cch: Add, Button, vshk gSaveOpenMenuHK xs, Save Hotkey

gui, cch: font, c4B0082, Consolas
gui, cch: add, GroupBox, x20 y660 w300 h80  , [ Colors Tile Size ]
gui, cch: font, c000000, Consolas
iniread, ColorMenuTileSize, %inifile%, ColorMenuOptions, ColorMenuTileSize
gui, cch: add, edit, xp+10 yp+20 w50 section vnewtilesize Number, %ColorMenuTileSize%
gui, cch: add, text, x+p, %a_space%%a_space%pixels
Gui, cch: Add, Button, vsntbut gSaveNewTileSize x+10, Save Tile Size 
gui, cch: add, text, xs w280 wrap, Enter a pixel size between 16 and 72.



gui, cch: font, c4B0082, Consolas
gui, cch: add, GroupBox, x325 y60 w300 h555 section , [ Color Menu Layout ]
gui, cch: font, c000000, Consolas

global LayoutSection := ""
global LayoutEdit 
global allowsave

iniread, LayoutSection, %inifile%, ColorMenuLayout
GuiControl,, LayoutEdit, %LayoutSection%

gui, cch: add, Edit, xp+10 yp+20 w280 r30 gQCMOnChange vLayoutEdit, %LayoutSection%
Gui, cch: Add, Button, disabled vallowsave gSaveLayOut h12 , Save Layout

	gui, cch: add, picture, w24 h24 x+15+p hwndhlay gdummy, %icons%\about.ico
	AddTooltip(hlay, "You can change the layout order`nof the colors in your menu in the box above`nor directly in the -settings.ini file.`n`nCut & paste to rearrange them & then save.`nAdd a Separator with * line= * between colors.")
gui, cch: Add, picture, w24 h24 x+15+p hwndhupdini gRefreshNewINI, %icons%\view-refresh xfav_32x32.ico
addtooltip(Hupdini, "Refresh Menu Layout`n`nRe-Reads from the INI if you added`ncolors while this window was open.")
gui, cch: font, c4B0082, Consolas
gui, cch: add, GroupBox, x325 y625 w300 h115 , [ * ! NOTE ! * ]

gui, cch: font, c000000 s09, Consolas
gui, cch: add, Text, xp+10 yp+20 w280 section, Most of the settings in this window update live! These are just a few options affecting the main menu. And there are **more** options you can change in the -SETTINGS.ini file. You should manually reload QCM after making changes there.

; gui, cch: Font
; gui, cch: Font, s10 ; cSilver, Consolas
; gui, cch: +AlwaysOnTop
if (Xg)
	gui, cch: Show, x%Xg% y%Yg%, ?? Quick Color Menu Settings && Info
else 
	gui, cch: Show, autosize , ?? Quick Color Menu Settings && Info
GUIVis := 1
Return


Switch2QCMToolbar:
WinGetPos, Xg, Yg,,, ?? Quick Color Menu Settings && Info
IniWrite, %Xg%, %IniFile%, QCMConfig, Xg
IniWrite, %Yg%, %IniFile%, QCMConfig, Yg
iniwrite, 0, %inifile%, QCMConfig, GUIVis
sleep 150
gui, cch: Destroy
GUIVis := 0
ShowQCMToolbar:
IniWrite, 1, %inifile%, QCMConfig, ToolVis
iniread, TBIS, %inifile%, ColorMenuOptions, ToolbarIconSize
Gui, TB: destroy
Gui, TB: new

if (darkmode)
	Gui, TB: Color, c202124
else
	Gui, TB: Color, cE9E9E9

Gui, TB: Font, s10,  Consolas
; Gui, TB: Color, c202124,c252D13 ; darkmode colors
Gui, TB: margin, 10,10

; Gui, TB: Add, Text, gOpenColorMenu xm section, Show Menu 🡲
Gui, TB: add, picture,  w%TBIS% h%TBIS% hwndhsm gOpenColorMenu XM, %Icons%\Icons_039_COLORWHEELCUT_256x256.ico
AddTooltip(hsm, "Show Quick Color Menu")


Gui, TB: add, Picture, hwndhanc w%TBIS% h%TBIS% gShowAddColorMenu x+m, %icons%\eyedropper.ico
AddTooltip(hanc, "Show Add New Color Menu")


Gui, TB: add, Picture, hwndhssm w%TBIS% h%TBIS% gShowQCMsettingsmenu x+m, %icons%\setting gear cog JLicons_40_64x64.ico
AddTooltip(hssm, "Show Quick Settings Menu`n`nThere are few more settings not in the window below.")

Gui, TB: Add, picture, hwndheini w%TBIS% h%TBIS% gEditINI x+m, %icons%\settingsaltini.ico
addtooltip(heini, "Editing the -SETTINGS.ini File")

Gui, TB: Add, picture, hwndhrebut w%TBIS% h%TBIS% gReloadQCM x+m, %icons%\Reload.ico
AddTooltip(hrebut, "Reload App")

if FileExist(colorpicker1)
	{
	gui, TB: Add, picture, hwndhRCP1 w%TBIS% h%TBIS% grunColorPicker1 x+m, %colorpicker1%
	addtooltip(hRCP1, "Run your Color Picker")
	}
if FileExist(colorpicker2)
	{
	gui, TB: Add, picture, hwndhRCP2 w%TBIS% h%TBIS% grunColorPicker2 x+m, %colorpicker2%
	addtooltip(hRCP2, "Run your Color Picker")
	}
; Gui, TB: Add, Button, vcw gcchclose x+m, Close Window
Gui, TB: add, Picture, hwndhTB w%TBIS% h%TBIS% gExpandTB2Settings x+m, %icons%\toolbarExpand.ico
addtooltip(hTB, "Expand Toolbar into the Settings Window")

if (pin)
	{
		gui, tb: +AlwaysOnTop
		Gui, TB: add, picture, hwndhpit x+m w%TBIS% h%TBIS% gPinunpin, %pinNN%
	}
else
	{
		gui, tb: -AlwaysOnTop
		Gui, TB: add, picture, hwndhpit x+m w%TBIS% h%TBIS% gPinunpin, %pinFF%
	}
	
AddTooltip(hpit, "Pin \ Unpin Toolbar`nfrom Always on Top")

gui, tb: +toolwindow -dpiscale
if (Xt)
	gui, TB: show, x%Xt% y%Yt%, - Quick Color Menu Toolbar -
else
	Gui, TB: Show, AutoSize, - Quick Color Menu Toolbar -
	
Toolvis := 1

return

ExpandTB2Settings:
WinGetPos, Xt, Yt,,, - Quick Color Menu Toolbar -
iniWrite, %Xt%, %inifile%, QCMConfig, Xt
IniWrite, %Yt%, %inifile%, QCMConfig, Yt
IniWrite, 0, %inifile%, QCMConfig, Toolvis
sleep 150
gui, TB: Destroy
ToolVis := 0
S2GUI := 1
gosub CChelp
return


AlwaysOnTopToggle:
pinunpin:
; Gui, Add, CheckBox, hWndhpintip vpin gpinunpin +Checked x+15+m, Pin\Unpin to Top ;
; global pin, pinFF, piNN, pinstartpic
gui, submit, nohide
if (pin)
	{
		Gui, TB: -alwaysontop
		GuiControl,,pin,%pinFF%
		pin := 0
		tooltip, Unpinned!
		iniwrite, 0, %inifile%, QCMConfig, Pin
	}
else
	{
		Gui, TB: +alwaysontop
		GuiControl,,pin,%pinNN%
		pin := 1
		tooltip, Pinned to Top!
		iniwrite, 1, %inifile%, QCMConfig, Pin
	}
SetTimer, RemoveToolTip, -1500
return


relaseguipin:
gui, cch: -AlwaysOnTop
SetTimer, relaseguipin, Off
s2gui := 0
return
SaveOpenMenuHK: ;; Save Hotkey 
    Gui, cch: Submit, NoHide
    
    ; Format the new hotkey including Win key if checked
    FinalNewHotkey := WINKEY ? "#" . NewOpenColorMenu : NewOpenColorMenu
    
    ; Only make changes if the hotkey actually changed
    if (FinalNewHotkey != CurrentColorMenuHotkey && FinalNewHotkey != "#") {
        ; First turn off old hotkey if it exists
        if (CurrentColorMenuHotkey != "") {
            Hotkey, %CurrentColorMenuHotkey%, OpenColorMenu, Off
            ToolTip, Turning off: %CurrentColorMenuHotkey%
            Sleep, 100
        }
        
        ; Then register the new hotkey if it's not empty
        if (FinalNewHotkey != "") {
            Hotkey, %FinalNewHotkey%, OpenColorMenu, On
            ToolTip, Turning on: %FinalNewHotkey%
            Sleep, 100
        }
        
        ; Update tracking variables and save to INI
        CurrentColorMenuHotkey := FinalNewHotkey
        IniWrite, %FinalNewHotkey%, %inifile%, Global_Hotkeys, OpenColorMenu
        
        ; Rebuild the menu with new settings
        gosub BuildColorMenu
        
        ToolTip, Hotkey Updated!
        SetTimer, RemoveToolTip, -2000
    } else if (FinalNewHotkey = "#") {
        ; Prevent assigning just the Windows key as a hotkey
        ToolTip, Cannot use just the Windows key as a hotkey
        SetTimer, RemoveToolTip, -2000
    }
return


reloadtooltip:
tooltip A Reload is required for this Change to take effect.
SetTimer, RemoveToolTip, -2500 
return
listofkeys:
run, https://www.autohotkey.com/docs/v1/KeyList.htm
return
QCMOnChange: ; Triggered when the content of the edit box changes
Gui, cch: Submit, NoHide
If (LayoutEdit != LayoutSection)
    GuiControl, cch: Enable, allowsave
Else ; Disable the button if the edit box is not changed
    GuiControl, cch: Disable, allowsave
Return
RefreshNewINI:
tooltip, working on it...
SetTimer, RemoveToolTip, -1500
GuiControl,, LayoutEdit, ; clear the current edit field 
iniread, LayoutSection, %inifile%, ColorMenuLayout ;; reread the sections
GuiControl,, LayoutEdit, %LayoutSection% ;; update the gui
return
SaveLayOut: 
tooltip Saving New Layout ...

filecopy, %inifile%, %inifile%.BAK	; make a backup of current .ini
sleep 200
FileSetAttrib, +H, %inifile%.BAK  	;  and hide it.
GuiControlGet, NewLayout, , LayoutEdit 
NewLayout := RegExReplace(NewLayout, "\R", "`r`n") ;; normize line endings
NewLayout := RegExReplace(NewLayout, "(\r\n){2,}", "`r`n") ; remove empty lines as they cause issures in ini sections
Global NewLayout
IniDelete, %inifile%, ColorMenuLayout ; clear the old layout
sleep 500
FileAppend, [ColorMenuLayout]`r`n%NewLayout%`r`n, %inifile% ; Append the multiline layout manually
gosub BuildColorMenu ;; update the menu
iniread, LayoutSection, %inifile%, ColorMenuLayout ;; reread the sections
GuiControl,, LayoutEdit, %LayoutSection% ;; update the gui
sleep 800
tooltip
return

SaveDefaultClickAction:
Gui, Submit, NoHide
IniWrite, %DefaultClickAction%, %inifile%, ColorMenuOptions, DefaultClickAction
sleep 300
tooltip Default Click Action Updated!
SetTimer, RemoveToolTip, -2500 
return

ShowAddColorMenu:
gosub BuildColorMenu
menu, acc, show
return


;---------------------------------------------------------------------------

ChangeColorTileSize:
InputBox, NewTileSize , ECLM - Change Icon Size, To change the color tile size on the Qucik Color Code Menu`nenter a number between 16 and 72.`n`nThe default for windows is 16.`n,,,,,,,,24
if (NewTileSize = "") || (NewTileSize = ColorMenuTileSize) || (ErrorLevel)
	{
		Return
	}
if !RegExMatch(NewTileSize, "^\d+$") || (NewTileSize < 16) || (NewTileSize > 72)
	{
		tooltip Numbers only. Try again.
		SetTimer, RemoveToolTip, -2500
		goto ChangeColorTileSize
	}
else
	goto SaveNewTileSizetoINI
return

SaveNewTileSize:
gui, submit, nohide
if (NewTileSize = "") || (NewTileSize = ColorMenuTileSize) || (ErrorLevel)
	{
		Return
	}
if !RegExMatch(NewTileSize, "^\d+$") || (NewTileSize < 16) || (NewTileSize > 72)
	{
		tooltip Numbers only between 16 and 72 only. Try again.
		SetTimer, RemoveToolTip, -2500
		return ; goto ChangeColorTileSize
	}
else
	goto SaveNewTileSizetoINI
return

SaveNewTileSizetoINI:
IniWrite, %NewTileSize%, %inifile%, ColorMenuOptions, ColorMenuTileSize
sleep 300
tooltip, New Tile Size Saved.
SetTimer, RemoveToolTip, -2500
Return



;---------------------------------------------------------------------------
;; function to create color tiles icons
GenerateColorIcon(color) {
    global pToken, Tiles
	; msgbox %tiles%
    width := 64, height := 64
	filename := Tiles . color ".png"

	; Ensure colors folder exists
	if !FileExist(Tiles)  ; Check the full directory path
		FileCreateDir, %Tiles%  ; Create the full path

	if FileExist(filename)  ; Skip if already generated
		return

    ; Convert hex to RGB
	if !RegExMatch(color, "i)([A-F0-9]{2})([A-F0-9]{2})([A-F0-9]{2})", m)
		return
		
    ; RegExMatch(color, "([A-F0-9]{2})([A-F0-9]{2})([A-F0-9]{2})", m)
    r := "0x" m1, g := "0x" m2, b := "0x" m3

    ; Create a bitmap
    pBitmap := Gdip_CreateBitmap(width, height)
    pGraphics := Gdip_GraphicsFromImage(pBitmap)

    ; Set brush color
    pBrush := Gdip_BrushCreateSolid((r << 16) | (g << 8) | b | 0xFF000000)
    Gdip_FillRectangle(pGraphics, pBrush, 0, 0, width, height)

    ; Save to PNG
    Gdip_SaveBitmapToFile(pBitmap, filename)

    ; Cleanup
    Gdip_DeleteBrush(pBrush)
    Gdip_DeleteGraphics(pGraphics)
    Gdip_DisposeImage(pBitmap)
}




;===========================================================================
;===========================================================================
;===========================================================================

ShowColorGUIX:
    CCguiCount++  ; Increment for each new GUI
    guiName := "ColorGUI" CCguiCount
    CoordMode, Mouse, Screen
    MouseGetPos, msX, msY
    color := hexcc  ; Get color from clicked menu item
    If not RegExMatch(color, "i)^(0x|#)?([a-f0-9]){6}$")
    {
        Gosub, GetColor  ; Ensure valid color input
    }
    
    ; Create and show the new GUI
    Gui, %guiName%: New
    Gui, %guiName%: +AlwaysOnTop +Resize +Border +ToolWindow
    Gui, %guiName%: +LabelColorWin
    Gui, %guiName%: Color, %color%
	gui, %guiName%: add, picture, x10 y10 w24 h24 hwndhtico gdummy, %Icons%\Icons_039_COLORWHEELCUT_256x256.ico
    addtooltip(htico, "Double-Click or Ctrl + C = Copy HEX Code.`nCtrl + Q = Close Active Color Window`nCtrl + Shift + Q = Close *ALL* Color Windows")
    ; Add this GUI to the group
    GroupAdd, ColorMenuWindows, % "HEX #" color " - QCM Show Color - " CCguiCount
    
    Gui, %guiName%: Show, w350 h120 x%msX% y%msY%, HEX #%color% - QCM Show Color - %CCguiCount%
	ShowColorWindow := False
    return

CloseAllColorGUIs:
    Loop, % CCguiCount
    {
        Gui, ColorGUI%A_Index%: Destroy
    }
    CCguiCount := 0
    return

CloseColorWindowX: ;; gpt
    WinGetTitle, activeTitle, A
    if RegExMatch(activeTitle, "HEX #.*? - QCM Show Color - (\d+)", m)
    {
        guiIndex := m1
        Gui, ColorGUI%guiIndex%: Destroy
    }
return
; Use a single proper #IfWinActive directive
#IfWinActive ahk_group ColorMenuWindows
RButton:: ;; QCM - show QCM
    gosub OpenColorMenu
    return
^+Q:: ;; QCM - close all color window
gosub CloseAllColorGUIs
return
^q:: ;; QCM - close active color window
Gosub CloseColorWindowX
return
^c:: ;; QCM - copy hex code
GetShowColorWindowCode:
WinGetTitle, activeTitle, A
if RegExMatch(activeTitle, "HEX #(.*?) - QCM Show Color - (\d+)", m)
{
	color := m1
	guiIndex := m2
	; Gui, ColorGUI%guiIndex%: Destroy
	Clipboard =
	sleep 50
	Clipboard := m1
	clipwait,1
	if (clipboard != "")
		{
			tooltip, Copied:  %color%
			SetTimer, RemoveToolTip, -1500
		}
}
return
~Lbutton:: ;; QCM - copy hex code
WinGetTitle, winTitle, A
WinGetClass, winClass, A
if (A_PriorHotkey != "~Lbutton" or A_TimeSincePriorHotkey > 300)
	{
		KeyWait, Lbutton, u ; Too much time between presses, so this isn't a double-press.
		return
	}
else
	{
		gosub GetShowColorWindowCode
	}
return
; #todo, play with this. came out of showcolor.ahk script
; OnMessage(0x206, "WM_RBUTTONDBLCLK") ; Listening to the RButton DoubleClick event.
; WM_RBUTTONDOWN() {
    ; MouseGetPos, , , id
    ; Clipboard := color ; Give color to clipboard.
    ; If (Clipboard = color)
    ; {
        ; WinActivate, % "ahk_id " id
        ; ToolTip, % "Color: " Clipboard, 0, 0
        ; SetTimer, Label_RemoveToolTip, 1000
    ; }
    ; ToolTip
; }
#IfWinActive

GetColor:
    InputBox, color,, % "Please input a color value!", , , , , , , , % color?color:"2093ff"  ; Default color value "2093ff".
    If ErrorLevel    ; If the input value doesn't match the format, get it again.
        Return
    If not RegExMatch(color, "i)^(0x|#)?([a-f0-9]){6}$") {
        Gosub, GetColor
    }
    Return

Label_RemoveToolTip:
    SetTimer, % A_ThisLabel, Off
    ToolTip
    Return


;===========================================================================
;===========================================================================
;===========================================================================



RunColorMania:
try run, %colormania%
return
runColorPicker1:
try run, %ColorPicker1%
return
runColorPicker2:
try run, %ColorPicker2%
return

RunJustColorPicker:
if WinExist("Just Color Picker ahk_class TCustomForm")
	WinActivate
else
	run, %JustColorPicker%
return


editini:
if (A_username = "CLOUDEN")
	{
		Run, "X:\PFP\Notepad4\Notepad4.exe" "%inifile%"
		return
	}
try run %texteditor% "%inifile%"
catch
try run "%inifile%"
catch
run notepad.exe "%inifile%"
return




; ShowHTML16Menu=0 ;; wft ahk
makeini:

inilayout =
(
;; You should reload Quick Color Menu after making any changes to this settings file

[ColorMenuOptions]
;; *DefaultClickActions=* can be set to...
;; ... 1=Paste HEX Code*, 2=Copy HEX, 3=Paste RGB Code, 4=Copy RGB
DefaultClickAction=1
ColorMenuTileSize=24
DarkMode=1
ShowBasicsSubMenu=1
ShowAlphaSubMenu=1
ToolbarIconSize=24
StartLinkCreated=0
ShowToolbarOnStartup=1
;; The default action to carry out when Double-Clicking the Tray Icon.
; 1 = Show The Main Menu, 2 = Show QCM Toolbar, 3 = Show Quick Setting Menu, 4 = Show Settings Window
DefaultTrayDBLClickAction=1

[QCMConfig]
Pin=1
HideTrayIcon=0

[Global_Hotkeys]
OpenColorMenu=+Insert
;; Additional Hotkeys to show the main menu, if you want more than one
OpenColorMenu2=
OpenColorMenu3=
;; Additional Hotkeys for various menu controls that are not in the settings window...
ShowAddColorMenu=
AddNewColorFromScreen=
runColorPicker=
ChangeColorTileSize=
ShowHelpSettingWindow=
ShowQCMToolbar=
ReloadQCM=
EditINI=
ShowQCMsettingsMenu=
ExitQCM=
DarkModeToggle=
SwitchToShowColorWindowMode=

;; Hotkeys have to be formatted with AutoHotkeys Syntax.
;; AHKs Modifier keys symbols are...
;; ^ = Ctrl
;; + = Shift
;; ! = Alt
;; # = Windows Key ⊞
;; e.g...  Ctrl + Shift + F1 = ^+F1  .  or  .  Alt + Win + M = !#m 
;; For a Full List Hotkey Names && Special usages visit...
;; [AutoHotkey Documentation, List of Keys](https://www.autohotkey.com/docs/v1/KeyList.htm)


[Programs]
TextEditor = C:\Program Files\Notepad++\notepad++.exe
ShareX = C:\Program Files\ShareX\ShareX.exe
ColorPicker1 = X:\PFP\Just Color Picker\Just Color Picker.exe
ColorPicker2 = X:\PFP\ColorMania\ColorManiaPortable.exe
;; Paste the path to your favorite general color picker app.exe here 🡱 and
;; it will appear at the bottom of the menu, as a shortcut, so you can run it quickly.
;; CP#1 appears on the menu, both will appear on the toolbar.
;--------------------------------------------------
;; ↓ these specific color picker apps have special integration with the menu. you can add colors from them when they are open.
;; paste the .exe path for these apps ONLY if you use them. They can also exist in CP#1&2 spaces. when they are pasted here the + Add Color Menu will know to read the colors they are displaying
JustColorPicker = X:\PFP\Just Color Picker\Just Color Picker.exe
ColorMania = X:\PFP\ColorMania\ColorManiaPortable.exe

;; https://annystudio.com/software/colorpicker/
;; https://www.blacksunsoftware.com/colormania.html

[BasicColorsSubmenu]
FFFFFF=255, 255, 255
E9E9E9=233, 233, 233
A9A9A9=169, 169, 169
747474=116, 116, 116
454545=69, 69, 69
232323=35, 35, 35
0D0D0D=13, 13, 13
070707=7, 7, 7
000000=0, 0, 0
line=
FF0000=255, 0, 0
FF7F00=255, 127, 0
FFFF00=255, 255, 0
00FF00=0, 255, 0
0000FF=0, 0, 255
4B0082=75, 0, 130
8B00FF=139, 0, 255
line=
740000=116, 0, 0
007400=0, 116, 0
000074=0, 0, 116

[ColorMenuLayout]
64F000=100, 240, 0
0078D7=0, 120, 215
8AFFB0=138, 255, 176
FFFFAA=255, 255, 170
007400=0, 116, 0
000074=0, 0, 116
00AA00=0, 170, 0
line=
91C9F7=145, 201, 247
FFB900=255, 185, 0
3D5400=61, 84, 0
007400=0, 116, 0
line= 
004080=0, 64, 128
605C4D=96, 92, 77
CCA2A2=204, 162, 162
00AE51=0, 174, 81
AE5199=174, 81, 153
4A7DB5=74, 125, 181
C0C0C0=192, 192, 192
40361B=64, 54, 27
FFFF80=255, 255, 128
0F136F=15, 19, 111

)

FileAppend, %inilayout%, %inifile%, UTF-8
return

DarkModeToggle:
    If (DarkMode)
    {
		DarkMode := false
		MenuDark(3) ; Set to ForceLight
		iniwrite, 0, %inifile%, ColorMenuOptions, DarkMode
		sleep 200
		tooltip Dark Mode OFF!
			
    }
    else
    {
        DarkMode := true
        MenuDark(2) ; Set to ForceDark
		iniwrite, 1, %inifile%, ColorMenuOptions, DarkMode
		sleep 200
		tooltip Dark Mode ON!
	}
SetTimer, RemoveToolTip, -2000
gosub ReloadQCM
return

INIReadGlobal_Hotkeys()
{
    global
    IniRead, HotkeySection, %inifile%, Global_Hotkeys
    if (HotkeySection = "ERROR")
        return

    Loop, Parse, HotkeySection, `n, `r
    {
        if (A_LoopField = "")
            continue

        KeyParts := StrSplit(A_LoopField, "=")
        if (KeyParts.Length() < 2)
            continue

        LabelName := KeyParts[1]
        HotkeyValue := KeyParts[2]

        if (HotkeyValue = "" || HotkeyValue = "ERROR")
            continue

        try {
            Hotkey, %HotkeyValue%, %LabelName%, On
        } catch {
            continue
        }
    }
}



INIReadSection(sectionName) ;; function
{
    global
    IniRead, SectionContent, %inifile%, %sectionName%
    if (SectionContent = "ERROR")
        return

    Loop, Parse, SectionContent, `n, `r
    {
        if (A_LoopField = "")
            continue

        KeyParts := StrSplit(A_LoopField, "=")
        if (KeyParts.Length() < 2)
            continue

        VarName := KeyParts[1]
        VarValue := KeyParts[2]

        if (VarValue = "" || VarValue = "ERROR")
            VarValue := (sectionName = "Settings") ? 0 : ""  ; Default Settings to 0 if empty

        ; Assign dynamically as a global variable
        %VarName% := VarValue
    }
}


changetoolbariconsize:
iniread, curTBIS, %inifile%, ColorMenuOptions, ToolbarIconSize
newTBIS := A_thismenuitem
; newTBIS := str(newTBIS, px,"")
StringReplace, newTBIS, newTBIS, px, , 
; tooltip %A_thismenuitem% `n`nntbis:: %newTBIS%
if (newTBIS = curTBIS)
	return
iniwrite, %newTBIS%, %inifile%, ColorMenuOptions, ToolbarIconSize
if WinActive("- Quick Color Menu Toolbar - ahk_class AutoHotkeyGUI")
	{
		sleep 150
		gosub ReloadQCM
	}

return
ToggleToolbaronStart:
ShowToolbarOnStartup := !ShowToolbarOnStartup
if (ShowToolbarOnStartup)
{
	iniwrite, 1, %inifile%, ColorMenuOptions, ShowToolbarOnStartup
	menu, tbi, check, Show Toolbar On Start
}
else
{
	iniwrite, 0, %inifile%, ColorMenuOptions, ShowToolbarOnStartup
	menu, tbi, check, Show Toolbar On Start
}
Return


setmenu: ;; settings menu, menu, s, add
iniread, TBIS, %inifile%, ColorMenuOptions, ToolbarIconSize
curTBIS := TBIS " px"
; tooltip %curtbis%
menu, tbi, add
menu, tbi, deleteall
menu, tbi, add, Toolbar Icon Size, ShowQCMsettingsmenu
menu, tbi, icon, Toolbar Icon Size, %icons%\toolbarExpand.ico,,24
menu, tbi, add, ; line -------------------------
menu, tbi, add, 16 px, ChangeToolbarIconSize
menu, tbi, icon, 16 px, %icons%\winpos.ico
menu, tbi, add, 24 px, ChangeToolbarIconSize
menu, tbi, icon, 24 px, %icons%\winpos.ico
menu, tbi, add, 28 px, ChangeToolbarIconSize
menu, tbi, icon, 28 px, %icons%\winpos.ico
menu, tbi, add, 32 px, ChangeToolbarIconSize
menu, tbi, icon, 32 px, %icons%\winpos.ico
menu, tbi, add, 48 px, ChangeToolbarIconSize
menu, tbi, icon, 48 px, %icons%\winpos.ico
menu, tbi, check, %curTBIS% ; Add checkmark to the currently selected item
menu, tbi, default, %curTBIS% ; Add checkmark to the currently selected item
menu, tbi, add, ; line -------------------------
menu, tbi, add, Show Toolbar On Start, ToggleToolbaronStart
menu, tbi, icon, Show Toolbar On Start, %icons%\rocket_emoji_startup_64x64.ico
if (ShowToolbarOnStartup)
	menu, tbi, check, Show Toolbar On Start

menu, ccs, add
menu, ccs, deleteall
menu, ccs, add, Quick Color Menu -- Quick Settings`t%ShowQCMsettingsmenu%, ShowQCMsettingsmenu
menu, ccs, icon, Quick Color Menu -- Quick Settings`t%ShowQCMsettingsmenu%, %trayicon%,,24
menu, ccs, default, Quick Color Menu -- Quick Settings`t%ShowQCMsettingsmenu%,
menu, ccs, add, ; line -------------------------
menu, ccs, add, Open Settings && Info Window`t%ShowHelpSettingWindow%, colormenuhelpgui
menu, ccs, icon, Open Settings && Info Window`t%ShowHelpSettingWindow%, %icons%\about.ico,,24
menu, ccs, add, Show QCM Toolbar`t%ShowQCMToolbar%,ShowQCMToolbar
menu, ccs, icon, Show QCM Toolbar`t%ShowQCMToolbar%,%icons%\toolbar.ico,,24
menu, ccs, add, Toolbar Options >>>, :tbi
menu, ccs, icon, Toolbar Options >>>, %icons%\toolbarExpand.ico


menu, ccs, add, Change Color Tile Size`t%ColorMenuTileSize%px, ChangeColorTileSize
menu, ccs, icon, Change Color Tile Size`t%ColorMenuTileSize%px, %icons%\winpos.ico
menu, ccs, add, ; line -------------------------
menu, ccs, Add, Toggle  Dark <> Light  Theme`t%DarkModeToggle%, DarkModeToggle 
menu, ccs, icon, Toggle  Dark <> Light  Theme`t%DarkModeToggle%, %icons%\darkmode.ico


; menu, ccs, add, ; line -------------------------
menu, ccs, add, Preview Color Sample GUI`t%SwitchToShowColorWindowMode%, SwitchToShowColorWindowMode
menu, ccs, icon, Preview Color Sample GUI`t%SwitchToShowColorWindowMode%, %icons%\previeweye.ico

menu, ccs, add, ; line -------------------------

Startlink := A_StartMenu "\Programs\" ScriptName ".lnk"
global startlink
menu, ccs, add, Create Shortcut in Start Menu, startlink
menu, ccs, icon, Create Shortcut in Start Menu, %icons%\startmenu.ico	
if (StartLinkCreated)
{
	menu, ccs, togglecheck, Create Shortcut in Start Menu
	if !FileExist(startlink)
		FileCreateShortcut, %A_ScriptFullPath%, %A_StartMenu%\Programs\%ScriptName%.lnk,,,%Description%,%trayicon%,,0
}
else
{
	 if FileExist(startlink)
		FileDelete,%startlink%
	menu, ccs, add, Create Shortcut in Start Menu, startlink
}

startuplink := A_StartUp "\" Scriptname ".lnk"
global startuplink
menu, ccs, add, Run QCM at System Start Up, togRunonStartUp
menu, ccs, icon, Run QCM at System Start Up, %icons%\rocket_emoji_startup_64x64.ico
if (RunonStartUP)
	{
	menu, ccs, ToggleCheck, Run Quick Color Menu at Start Up
	if !FileExist(startuplink)
		FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%ScriptName%.lnk,%A_scriptdir%,,Runs %a_scriptname% at Startup,%trayicon%,,0,
	}
else
	{
	if FileExist(startuplink)
		FileDelete, %startuplink%
	}
menu, ccs, add, ; line -------------------------

menu, ccs, add, Edit Settings File`t%editini%, editini
menu, ccs, icon, Edit Settings File`t%editini%, %icons%\settingsaltini.ico
menu, ccs, add, Open App Folder`t%openscriptdir%, openscriptdir
menu, ccs, icon, Open App Folder`t%openscriptdir%, explorer.exe
if !(A_IsCompiled)
{
menu, ccs, add, Edit Script`t%EditScrip%, editscript
if FileExist(TextEditor)
	menu, ccs, icon, Edit Script`t%EditScrip%, %TextEditor%
else
	menu, ccs, icon, Edit Script`t%EditScrip%, notepad.exe
}
menu, ccs, add, ; line ------------------------- 
menu, ccs, add, Hide System Tray Icon, TrayIconToggle
if (HideTrayIcon)
	Menu, ccs, ToggleCheck, Hide System Tray Icon
else
	menu, ccs, icon, Hide System Tray Icon, %trayicon%
	
menu, ccs, add, Clean Out Tiles Folder, CleanOutTilesFolder
menu, ccs, icon, Clean Out Tiles Folder, %icons%\Trashbin.ico
menu, ccs, add, Reload`t%ReloadQCM%, ReloadQCM
menu, ccs, icon, Reload`t%ReloadQCM%, %icons%\reload.ico
menu, ccs, add, ; line ------------------------- 
menu, ccs, add, Visit Github Webpage`t%visitgithubwebpage%, VisitGithubQCM
menu, ccs, icon, Visit Github Webpage`t%visitgithubwebpage%, %icons%\Githubicon.ico
menu, ccs, add, Quit \ Exit`t%exitQCM%, exitQCM
menu, ccs, icon, Quit \ Exit`t%exitQCM%, %icons%\exitapp.ico
; If (A_username = "CLOUDEN")
; If !(A_IsCompiled)
	; {

	; }
return

ShowQCMsettingsmenu:
gosub setmenu
menu, ccs, show
return
CleanOutTilesFolder:
; msgbox %A_scriptdir%\Color Menu Tiles
sleep 100
FileRecycle, %tiles%
sleep 100
return

SwitchToShowColorWindowMode:
Tooltip The menu will re-open.`nPick a color to sample to view on screen.
sleep 2000
ShowColorWindow := True
gosub BuildColorMenu
menu, cc, show
ShowColorWindow := False
tooltip
return

TrayIconToggle:
iniread, trayiconset, %inifile%, QCMConfig, HideTrayIcon
; if WinExist("- Quick Color Menu Toolbar -")
	; Winset -AlwaysOnTop
if (trayiconset)
	goto ApplyTrayandReloadNow
else
	goto warntrayicon
warntrayicon:
SetTimer, trayiconmsgboxbuts, -50
MsgBox, 262659, - QCM - Hide Tray Icon ?, A Reload is required to apply this setting.`n`nAlso note you will only be able to access QCM with its hotkey when the tray icon is turn off.`n`nContinue ... ?`n
IfMsgBox Yes
	{
		goto ApplyTrayandReloadNow
	}
IfMsgBox No
	{
		Goto TrayIconToggleOK
	}
IfMsgBox Cancel
	{
		return
	}
IfMsgBox Timeout
	{
	
	}
Return

trayiconmsgboxbuts:
IfWinNotExist, - QCM - Hide Tray Icon ?
	Return
SetTimer, trayiconmsgboxbuts, Off
WinActivate
ControlSetText, Button1, Apply && Reload
ControlSetText, Button2, OK
ControlSetText, Button3, No
Return


ApplyTrayandReloadNow:
ReloadNow := 1
TrayIconToggleOK:
HideTrayIcon := !HideTrayIcon
if (HideTrayIcon)
	{
		IniWrite, 1, %inifile%, QCMConfig, HideTrayIcon
		Menu, ccs, ToggleCheck, Hide System Tray Icon
	}
else
	{
		IniWrite, 0, %inifile%, QCMConfig, HideTrayIcon
		menu, ccs, icon, Hide System Tray Icon, %trayicon%		
	}
sleep 500
if (reloadnow)
	gosub ReloadQCM
return


openscriptdir:
run "%a_scriptdir%"
return

Editscript:
if !(A_IsCompiled)
	{
		Try run %TextEditor% "%a_scriptfullpath%"
	catch
		Run, Notepad.exe "%a_scriptfullpath%"
	}
else
	Run "%A_scriptdir%"
return

visitgithubQCM:
run https://github.com/indigofairyx/Quick-Color-Menu/
return

startlink:
StartLinkCreated := !StartLinkCreated
if (StartLinkCreated)
{
	iniwrite, 1, %inifile%, ColorMenuOptions, StartLinkCreated
	FileCreateShortcut, %A_ScriptFullPath%, %A_StartMenu%\Programs\%ScriptName%.lnk,,,%Description%,%trayicon%,,0
	menu, ccs, ToggleCheck, Create Shortcut in Start Menu
}
else
{
	iniwrite, 0, %inifile%, ColorMenuOptions, StartLinkCreated
	; FileDelete, %A_startmenu%\%startlink%.lnk
	FileDelete,%startlink%
	menu, ccs, ToggleCheck, Create Shortcut in Start Menu
}
return

togRunonStartUp:
RunonStartUP := !RunonStartUP
if (RunonStartUP) ;; if run on startup create a .lnk in %appdatae%\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
	{
		IniWrite, 1, %inifile%, ColorMenuOptions, RunonStartUP
		FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%ScriptName%.lnk,,,Runs "%A_ScriptName%" at Startup,%trayicon%,,0
		menu, ccs, togglecheck, Run Quick Color Menu at Start Up

	}
else ; if dont run on startup delete the .lnk from %appdatae%\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
	{
		IniWrite, 0, %inifile%, ColorMenuOptions, RunonStartUP
		FileDelete, %A_StartUp%\%ScriptName%.lnk
		menu, ccs, togglecheck, Run Quick Color Menu at Start Up
	}
sleep 400
return


;***************************************************************************
; STANDARD LABELS **********************************************************

ExitHandler() {
    Gdip_Shutdown(pToken)
	RememberWinPos()
	; iniwrite, %A_ExitReason%, %inifile%, QCMConfig, ExitReason
}

RememberWinPos() ;; function
{
	global
	if (GUIVis)
	{
		; iniwrite, 1, %inifile%, QCMConfig, GUIVis
		WinGetPos, Xg, Yg,,, ?? Quick Color Menu Settings && Info
		IniWrite, %Xg%, %IniFile%, QCMConfig, Xg
		IniWrite, %Yg%, %IniFile%, QCMConfig, Yg
	}
	if (ToolVis)
	{
		; iniwrite, 1, %inifile%, QCMConfig, GUIVis
		WinGetPos, Xt, Yt,,, - Quick Color Menu Toolbar -
		iniWrite, %Xt%, %inifile%, QCMConfig, Xt
		IniWrite, %Yt%, %inifile%, QCMConfig, Yt	
	}
; sleep 150
}

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
return

ReloadQCM:
tooltip Reloading...`n Quick Color Menu
RememberWinPos()
; if (GUIVis)
	; iniwrite, 1, %inifile%, QCMConfig, GUIVis
; if (ToolVis)
	; iniwrite, 1, %inifile%, QCMConfig, GUIVis
sleep 750
Reload
return


CloseHelpWindow:
cchclose:
CCHGuiEscape:
CChGuiClose:
RememberWinPos()
iniwrite, 0, %inifile%, QCMConfig, GUIVis
gui, cch: destroy
GUIVis := 0
return

TBGuiEscape:
TBGuiClose:
RememberWinPos()
iniwrite, 0, %inifile%, QCMConfig, ToolVis
gui, TB: destroy
ToolVis := 0
return

ExitQCMviaGUI:
gui, cch:destroy
iniwrite, 0, %inifile%, QCMConfig, GUIVis
sleep 200
exitQCM:
ExitApp ; Terminate the script unconditionally
return

Dummy:
DoNothing:
return
RemoveToolTip:
ToolTip
Return




hexpercentFULL:
menu, ha, add
menu, ha, deleteall

menu, ha, add, Alpha ##`tPercent, dummy
menu, ha, icon, Alpha ##`tPercent, %icons%\rgb alpha transp 64.ico,,24
menu, ha, default, Alpha ##`tPercent
menu, ha, add, ; line -------------------------
menu, ha, add, FF`t100`%, copyalpha
menu, ha, add, FC`t99`%, copyalpha
menu, ha, add, FA`t98`%, copyalpha
menu, ha, add, F7`t97`%, copyalpha
menu, ha, add, F5`t96`%, copyalpha
menu, ha, add, F2`t95`%, copyalpha
menu, ha, add, F0`t94`%, copyalpha
menu, ha, add, ED`t93`%, copyalpha
menu, ha, add, EB`t92`%, copyalpha
menu, ha, add, E8`t91`%, copyalpha
menu, ha, add, E6`t90`%, copyalpha
menu, ha, add, E3`t89`%, copyalpha
menu, ha, add, E0`t88`%, copyalpha
menu, ha, add, DE`t87`%, copyalpha
menu, ha, add, DB`t86`%, copyalpha
menu, ha, add, D9`t85`%, copyalpha
menu, ha, add, D6`t84`%, copyalpha
menu, ha, add, D4`t83`%, copyalpha
menu, ha, add, D1`t82`%, copyalpha
menu, ha, add, CF`t81`%, copyalpha
menu, ha, add, CC`t80`%, copyalpha
menu, ha, add, C9`t79`%, copyalpha
menu, ha, add, C7`t78`%, copyalpha
menu, ha, add, C4`t77`%, copyalpha
menu, ha, add, C2`t76`%, copyalpha
menu, ha, add, BF`t75`%, copyalpha
menu, ha, add, BD`t74`%, copyalpha
menu, ha, add, BA`t73`%, copyalpha
menu, ha, add, B8`t72`%, copyalpha
menu, ha, add, B5`t71`%, copyalpha
menu, ha, add, B3`t70`%, copyalpha
menu, ha, add, B0`t69`%, copyalpha
menu, ha, add, AD`t68`%, copyalpha
menu, ha, add, AB`t67`%, copyalpha
menu, ha, add, A8`t66`%, copyalpha
menu, ha, add, A6`t65`%, copyalpha
menu, ha, add, A3`t64`%, copyalpha
menu, ha, add, A1`t63`%, copyalpha
menu, ha, add, 9E`t62`%, copyalpha
menu, ha, add, 9C`t61`%, copyalpha
menu, ha, add, 99`t60`%, copyalpha
menu, ha, add, 96`t59`%, copyalpha
menu, ha, add, 94`t58`%, copyalpha
menu, ha, add, 91`t57`%, copyalpha
menu, ha, add, 8F`t56`%, copyalpha
menu, ha, add, 8C`t55`%, copyalpha
menu, ha, add, 8A`t54`%, copyalpha
menu, ha, add, 87`t53`%, copyalpha
menu, ha, add, 85`t52`%, copyalpha
menu, ha, add, 82`t51`%, copyalpha
menu, ha, add, 80`t50`%, copyalpha
menu, ha, add, 7D`t49`%, copyalpha
menu, ha, add, 7A`t48`%, copyalpha
menu, ha, add, 78`t47`%, copyalpha
menu, ha, add, 75`t46`%, copyalpha
menu, ha, add, 73`t45`%, copyalpha
menu, ha, add, 70`t44`%, copyalpha
menu, ha, add, 6E`t43`%, copyalpha
menu, ha, add, 6B`t42`%, copyalpha
menu, ha, add, 69`t41`%, copyalpha
menu, ha, add, 66`t40`%, copyalpha
menu, ha, add, 63`t39`%, copyalpha
menu, ha, add, 61`t38`%, copyalpha
menu, ha, add, 5E`t37`%, copyalpha
menu, ha, add, 5C`t36`%, copyalpha
menu, ha, add, 59`t35`%, copyalpha
menu, ha, add, 57`t34`%, copyalpha
menu, ha, add, 54`t33`%, copyalpha
menu, ha, add, 52`t32`%, copyalpha
menu, ha, add, 4F`t31`%, copyalpha
menu, ha, add, 4D`t30`%, copyalpha
menu, ha, add, 4A`t29`%, copyalpha
menu, ha, add, 47`t28`%, copyalpha
menu, ha, add, 45`t27`%, copyalpha
menu, ha, add, 42`t26`%, copyalpha
menu, ha, add, 40`t25`%, copyalpha
menu, ha, add, 3D`t24`%, copyalpha
menu, ha, add, 3B`t23`%, copyalpha
menu, ha, add, 38`t22`%, copyalpha
menu, ha, add, 36`t21`%, copyalpha
menu, ha, add, 33`t20`%, copyalpha
menu, ha, add, 30`t19`%, copyalpha
menu, ha, add, 2E`t18`%, copyalpha
menu, ha, add, 2B`t17`%, copyalpha
menu, ha, add, 29`t16`%, copyalpha
menu, ha, add, 26`t15`%, copyalpha
menu, ha, add, 24`t14`%, copyalpha
menu, ha, add, 21`t13`%, copyalpha
menu, ha, add, 1F`t12`%, copyalpha
menu, ha, add, 1C`t11`%, copyalpha
menu, ha, add, 1A`t10`%, copyalpha
menu, ha, add, 17`t9`%, copyalpha
menu, ha, add, 14`t8`%, copyalpha
menu, ha, add, 12`t7`%, copyalpha
menu, ha, add, 0F`t6`%, copyalpha
menu, ha, add, 0D`t5`%, copyalpha
menu, ha, add, 0A`t4`%, copyalpha
menu, ha, add, 08`t3`%, copyalpha
menu, ha, add, 05`t2`%, copyalpha
menu, ha, add, 03`t1`%, copyalpha
menu, ha, add, 00`t0`%, copyalpha

return 

hexalpha5ths:
menu, ha, add
menu, ha, deleteall

menu, ha, add, Alpha ##`tPercent, dummy
menu, ha, icon, Alpha ##`tPercent, %icons%\rgb alpha transp 64.ico,,24
menu, ha, default, Alpha ##`tPercent
menu, ha, add, ; line -------------------------
menu, ha, add, FF`t100`%, copyalpha
menu, ha, add, F2`t95`%, copyalpha
menu, ha, add, E6`t90`%, copyalpha
menu, ha, add, D9`t85`%, copyalpha
menu, ha, add, CC`t80`%, copyalpha
menu, ha, add, ; line -------------------------
menu, ha, add, BF`t75`%, copyalpha
menu, ha, add, B3`t70`%, copyalpha
menu, ha, add, A6`t65`%, copyalpha
menu, ha, add, 99`t60`%, copyalpha
menu, ha, add, 8C`t55`%, copyalpha
menu, ha, add, ; line -------------------------
menu, ha, add, 80`t50`%, copyalpha
menu, ha, add, 73`t45`%, copyalpha
menu, ha, add, 66`t40`%, copyalpha
menu, ha, add, 59`t35`%, copyalpha
menu, ha, add, 4D`t30`%, copyalpha
menu, ha, add, ; line -------------------------
menu, ha, add, 40`t25`%, copyalpha
menu, ha, add, 33`t20`%, copyalpha
menu, ha, add, 26`t15`%, copyalpha
menu, ha, add, 1A`t10`%, copyalpha
menu, ha, add, 0D`t5`%, copyalpha
menu, ha, add, ; line -------------------------
menu, ha, add, 00`t0`%, copyalpha

return 

copyalpha:
selected := A_ThisMenuItem
parts := StrSplit(selected, "`t")  ; Split at `t

hexA := parts[1]  ; The HEX Alpha code
Percent := parts[2]  ; Percent Reference
; MsgBox %hexa%`n`n%percent% ; 1A 0D40% 15% 90%
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))  ; Copy RGB
	{

		clipboard := ""
		sleep 50
		clipboard := Percent
		clipwait,0.5
		If (clipboard != "")
			{
				Tooltip Copied: %Percent%
				SetTimer, RemoveToolTip, -1500
			}
		return
	}
if (GetKeyState("Control", "P"))  ; Send RGB
    {
        sendraw, %Percent%
        return
    }
if (GetKeyState("Shift", "P"))  ; Copy HEX
    {
        clipboard := ""
        sleep 50
        clipboard := hexA
        clipwait,0.5
        If (clipboard != "")
            {
                Tooltip Copied:  %hexA%
                SetTimer, RemoveToolTip, -1500
            }
        return
    }
else
{
        if WinActive("Color ahk_class #32770") || WinActive("color ahk_class #32770")
        {
			tooltip Windows Color Picker Can't handle Alpha Channels
			SetTimer, RemoveToolTip, -1500
			return
        }
		else
        {
            ; Execute the appropriate default action
            if (DefaultAction = 1)  ; Send HEX
            {
                sendraw %hexA%
            }
            else if (DefaultAction = 2)  ; Copy HEX
            {
                clipboard := ""
                sleep 50
                clipboard := hexA
                clipwait,0.5
                If (clipboard != "")
                {
                    Tooltip Copied:  %hexA%
                    SetTimer, RemoveToolTip, -1500
                }
            }
            else if (DefaultAction = 3)  ; Send RGB
            {
                sendraw, %Percent%
            }
            else if (DefaultAction = 4)  ; Copy RGB
            {
                clipboard := ""
                sleep 50
                clipboard := Percent
                clipwait,0.5
                If (clipboard != "")
                {
                    Tooltip Copied: %Percent%
                    SetTimer, RemoveToolTip, -1500
                }
            }
        }

}
return

buildHtml16Menu:
GenerateColorIcon("00FFFF")
GenerateColorIcon("000000")
GenerateColorIcon("0000FF")
GenerateColorIcon("FF00FF")
GenerateColorIcon("808080")
GenerateColorIcon("008000")
GenerateColorIcon("00FF00")
GenerateColorIcon("800000")
GenerateColorIcon("000080")
GenerateColorIcon("808000")
GenerateColorIcon("800080")
GenerateColorIcon("FF0000")
GenerateColorIcon("C0C0C0")
GenerateColorIcon("008080")
GenerateColorIcon("FFFFFF")
GenerateColorIcon("FFFF00")
menu, h16, add
menu, h16, deleteall
menu, h16, add, 16 Html Colors`tHEX#  -  RRR`,GGG`,BBB, dummy
menu, h16, icon, 16 Html Colors`tHEX#  -  RRR`,GGG`,BBB, %icons%file_extension_html__32x32.ico,,24
menu, h16, default, 16 Html Colors`tHEX#  -  RRR`,GGG`,BBB
menu, h16, add, ; line -------------------------

; GenerateColorIcon(00FFFF)
; GenerateColorIcon(000000)
; GenerateColorIcon(0000FF)
; GenerateColorIcon(FF00FF)
; GenerateColorIcon(808080)
; GenerateColorIcon(008000)
; GenerateColorIcon(00FF00)
; GenerateColorIcon(800000)
; GenerateColorIcon(000080)
; GenerateColorIcon(808000)
; GenerateColorIcon(800080)
; GenerateColorIcon(FF0000)
; GenerateColorIcon(C0C0C0)
; GenerateColorIcon(008080)
; GenerateColorIcon(FFFFFF)
; GenerateColorIcon(FFFF00)
; msgbox %tiles%
; run, %A_scriptdir%\Color Menu Tiles\00FFFF.png
menu, h16, add, Aqua`t00FFFF  -  000`,255`,255, Sendhtml16
menu, h16, icon, Aqua`t00FFFF  -  000`,255`,255, %A_scriptdir%\Color Menu Tiles\00FFFF.png,, %ColorMenuTileSize%
menu, h16, add, Black`t000000  -  000`,000`,000, Sendhtml16
menu, h16, icon, Black`t000000  -  000`,000`,000, %A_scriptdir%\Color Menu Tiles\000000.png,, %ColorMenuTileSize%
menu, h16, add, Blue`t0000FF  -  000`,000`,255, Sendhtml16
menu, h16, icon, Blue`t0000FF  -  000`,000`,255, %A_scriptdir%\Color Menu Tiles\0000FF.png,, %ColorMenuTileSize%
menu, h16, add, Fuchsia`tFF00FF  -  255`,000`,255, Sendhtml16
menu, h16, icon, Fuchsia`tFF00FF  -  255`,000`,255, %A_scriptdir%\Color Menu Tiles\FF00FF.png,, %ColorMenuTileSize%
menu, h16, add, Gray`t808080  -  128`,128`,128, Sendhtml16
menu, h16, icon, Gray`t808080  -  128`,128`,128, %A_scriptdir%\Color Menu Tiles\808080.png,, %ColorMenuTileSize%
menu, h16, add, Green`t008000  -  000`,128`,000, Sendhtml16
menu, h16, icon, Green`t008000  -  000`,128`,000, %A_scriptdir%\Color Menu Tiles\008000.png,, %ColorMenuTileSize%
menu, h16, add, Lime`t00FF00  -  000`,255`,000, Sendhtml16
menu, h16, icon, Lime`t00FF00  -  000`,255`,000, %A_scriptdir%\Color Menu Tiles\00FF00.png,, %ColorMenuTileSize%
menu, h16, add, Maroon`t800000  -  128`,000`,000, Sendhtml16
menu, h16, icon, Maroon`t800000  -  128`,000`,000, %A_scriptdir%\Color Menu Tiles\800000.png,, %ColorMenuTileSize%
menu, h16, add, Navy`t000080  -  000`,000`,128, Sendhtml16
menu, h16, icon, Navy`t000080  -  000`,000`,128, %A_scriptdir%\Color Menu Tiles\000080.png,, %ColorMenuTileSize%
menu, h16, add, Olive`t808000  -  128`,128`,000, Sendhtml16
menu, h16, icon, Olive`t808000  -  128`,128`,000, %A_scriptdir%\Color Menu Tiles\808000.png,, %ColorMenuTileSize%
menu, h16, add, Purple`t800080  -  128`,000`,128, Sendhtml16
menu, h16, icon, Purple`t800080  -  128`,000`,128, %A_scriptdir%\Color Menu Tiles\800080.png,, %ColorMenuTileSize%
menu, h16, add, Red`tFF0000  -  255`,000`,000, Sendhtml16
menu, h16, icon, Red`tFF0000  -  255`,000`,000, %A_scriptdir%\Color Menu Tiles\FF0000.png,, %ColorMenuTileSize%
menu, h16, add, Silver`tC0C0C0  -  192`,192`,192, Sendhtml16
menu, h16, icon, Silver`tC0C0C0  -  192`,192`,192, %A_scriptdir%\Color Menu Tiles\C0C0C0.png,, %ColorMenuTileSize%
menu, h16, add, Teal`t008080  -  000`,128`,128, Sendhtml16
menu, h16, icon, Teal`t008080  -  000`,128`,128, %A_scriptdir%\Color Menu Tiles\008080.png,, %ColorMenuTileSize%
menu, h16, add, White`tFFFFFF  -  255`,255`,255, Sendhtml16
menu, h16, icon, White`tFFFFFF  -  255`,255`,255, %A_scriptdir%\Color Menu Tiles\FFFFFF.png,, %ColorMenuTileSize%
menu, h16, add, Yellow`tFFFF00  -  255`,255`,000, sendhtml16
menu, h16, icon, Yellow`tFFFF00  -  255`,255`,000, %A_scriptdir%\Color Menu Tiles\FFFF00.png,, %ColorMenuTileSize%
menu, h16, add, ; line -------------------------
menu, h16, add, `tRefreance Menu Only, sendhtml16


return
; X:\AHK\Icons\Color Menu Tiles

showhtml16menu:
gosub buildHtml16Menu
menu, h16, show
return

;; end script, end QCM
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
; Gdip Library for creating menu icon pngs
;---------------------------------------------------------------------------


; Gdip standard library v1.54 on 11/15/2017
; Gdip standard library v1.53 on 6/19/2017
; Gdip standard library v1.52 on 6/11/2017
; Gdip standard library v1.51 on 1/27/2017
; Gdip standard library v1.50 on 11/20/16
; Gdip standard library v1.45 by tic (Tariq Porter) 07/09/11
; Modifed by Rseding91 using fincs 64 bit compatible Gdip library 5/1/2013
; Supports: Basic, _L ANSi, _L Unicode x86 and _L Unicode x64
;
; Updated 11/15/2017 - compatibility with both AHK v2 and v1, restored by nnnik
; Updated 6/19/2017 - Fixed few bugs from old syntax by Bartlomiej Uliasz
; Updated 6/11/2017 - made code compatible with new AHK v2.0-a079-be5df98 by Bartlomiej Uliasz
; Updated 1/27/2017 - fixed some bugs and made #Warn All compatible by Bartlomiej Uliasz
; Updated 11/20/2016 - fixed Gdip_BitmapFromBRA() by 'just me'
; Updated 11/18/2016 - backward compatible support for both AHK v1.1 and AHK v2
; Updated 11/15/2016 - initial AHK v2 support by guest3456
; Updated 2/20/2014 - fixed Gdip_CreateRegion() and Gdip_GetClipRegion() on AHK Unicode x86
; Updated 5/13/2013 - fixed Gdip_SetBitmapToClipboard() on AHK Unicode x64
;


; STATUS ENUMERATION
; Return values for functions specified to have status enumerated return type

;
; Ok =						= 0
; GenericError				= 1
; InvalidParameter			= 2
; OutOfMemory				= 3
; ObjectBusy				= 4
; InsufficientBuffer		= 5
; NotImplemented			= 6
; Win32Error				= 7
; WrongState				= 8
; Aborted					= 9
; FileNotFound				= 10
; ValueOverflow				= 11
; AccessDenied				= 12
; UnknownImageFormat		= 13
; FontFamilyNotFound		= 14
; FontStyleNotFound			= 15
; NotTrueTypeFont			= 16
; UnsupportedGdiplusVersion	= 17
; GdiplusNotInitialized		= 18
; PropertyNotFound			= 19
; PropertyNotSupported		= 20
; ProfileNotFound			= 21
;


; FUNCTIONS

;
; UpdateLayeredWindow(hwnd, hdc, x:="", y:="", w:="", h:="", Alpha:=255)
; BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster:="")
; StretchBlt(dDC, dx, dy, dw, dh, sDC, sx, sy, sw, sh, Raster:="")
; SetImage(hwnd, hBitmap)
; Gdip_BitmapFromScreen(Screen:=0, Raster:="")
; CreateRectF(ByRef RectF, x, y, w, h)
; CreateSizeF(ByRef SizeF, w, h)
; CreateDIBSection
;


; Function:					UpdateLayeredWindow
; Description:				Updates a layered window with the handle to the DC of a gdi bitmap
;
; hwnd						Handle of the layered window to update
; hdc						Handle to the DC of the GDI bitmap to update the window with
; Layeredx					x position to place the window
; Layeredy					y position to place the window
; Layeredw					Width of the window
; Layeredh					Height of the window
; Alpha						Default = 255 : The transparency (0-255) to set the window transparency
;
; return					If the function succeeds, the return value is nonzero
;
; notes						If x or y omitted, then layered window will use its current coordinates
;							If w or h omitted then current width and height will be used

UpdateLayeredWindow(hwnd, hdc, x:="", y:="", w:="", h:="", Alpha:=255)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")

	if (w = "") || (h = "")
	{
		CreateRect( winRect, 0, 0, 0, 0 ) ;is 16 on both 32 and 64
		DllCall( "GetWindowRect", Ptr, hwnd, Ptr, &winRect )
		w := NumGet(winRect, 8, "UInt")  - NumGet(winRect, 0, "UInt")
		h := NumGet(winRect, 12, "UInt") - NumGet(winRect, 4, "UInt")
	}

	return DllCall("UpdateLayeredWindow"
	, Ptr, hwnd
	, Ptr, 0
	, Ptr, ((x = "") && (y = "")) ? 0 : &pt
	, "int64*", w|h<<32
	, Ptr, hdc
	, "int64*", 0
	, "uint", 0
	, "UInt*", Alpha<<16|1<<24
	, "uint", 2)
}



; Function				BitBlt
; Description			The BitBlt function performs a bit-block transfer of the color data corresponding to a rectangle
;						of pixels from the specified source device context into a destination device context.
;
; dDC					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of the area to copy
; dh					height of the area to copy
; sDC					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used, which copies the source directly to the destination rectangle
;
; BLACKNESS				= 0x00000042
; NOTSRCERASE			= 0x001100A6
; NOTSRCCOPY			= 0x00330008
; SRCERASE				= 0x00440328
; DSTINVERT				= 0x00550009
; PATINVERT				= 0x005A0049
; SRCINVERT				= 0x00660046
; SRCAND				= 0x008800C6
; MERGEPAINT			= 0x00BB0226
; MERGECOPY				= 0x00C000CA
; SRCCOPY				= 0x00CC0020
; SRCPAINT				= 0x00EE0086
; PATCOPY				= 0x00F00021
; PATPAINT				= 0x00FB0A09
; WHITENESS				= 0x00FF0062
; CAPTUREBLT			= 0x40000000
; NOMIRRORBITMAP		= 0x80000000

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster:="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdi32\BitBlt"
					, Ptr, dDC
					, "int", dx
					, "int", dy
					, "int", dw
					, "int", dh
					, Ptr, sDC
					, "int", sx
					, "int", sy
					, "uint", Raster ? Raster : 0x00CC0020)
}



; Function				StretchBlt
; Description			The StretchBlt function copies a bitmap from a source rectangle into a destination rectangle,
;						stretching or compressing the bitmap to fit the dimensions of the destination rectangle, if necessary.
;						The system stretches or compresses the bitmap according to the stretching mode currently set in the destination device context.
;
; ddc					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination rectangle
; dh					height of destination rectangle
; sdc					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used. It uses the same raster operations as BitBlt

StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster:="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdi32\StretchBlt"
					, Ptr, ddc
					, "int", dx
					, "int", dy
					, "int", dw
					, "int", dh
					, Ptr, sdc
					, "int", sx
					, "int", sy
					, "int", sw
					, "int", sh
					, "uint", Raster ? Raster : 0x00CC0020)
}



; Function				SetStretchBltMode
; Description			The SetStretchBltMode function sets the bitmap stretching mode in the specified device context
;
; hdc					handle to the DC
; iStretchMode			The stretching mode, describing how the target will be stretched
;
; return				If the function succeeds, the return value is the previous stretching mode. If it fails it will return 0
;
; STRETCH_ANDSCANS 		= 0x01
; STRETCH_ORSCANS 		= 0x02
; STRETCH_DELETESCANS 	= 0x03
; STRETCH_HALFTONE 		= 0x04

SetStretchBltMode(hdc, iStretchMode:=4)
{
	return DllCall("gdi32\SetStretchBltMode"
					, A_PtrSize ? "UPtr" : "UInt", hdc
					, "int", iStretchMode)
}



; Function				SetImage
; Description			Associates a new image with a static control
;
; hwnd					handle of the control to update
; hBitmap				a gdi bitmap to associate the static control with
;
; return				If the function succeeds, the return value is nonzero

SetImage(hwnd, hBitmap)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	E := DllCall( "SendMessage", Ptr, hwnd, "UInt", 0x172, "UInt", 0x0, Ptr, hBitmap )
	DeleteObject(E)
	return E
}



; Function				SetSysColorToControl
; Description			Sets a solid colour to a control
;
; hwnd					handle of the control to update
; SysColor				A system colour to set to the control
;
; return				If the function succeeds, the return value is zero
;
; notes					A control must have the 0xE style set to it so it is recognised as a bitmap
;						By default SysColor=15 is used which is COLOR_3DFACE. This is the standard background for a control
;
; COLOR_3DDKSHADOW				= 21
; COLOR_3DFACE					= 15
; COLOR_3DHIGHLIGHT				= 20
; COLOR_3DHILIGHT				= 20
; COLOR_3DLIGHT					= 22
; COLOR_3DSHADOW				= 16
; COLOR_ACTIVEBORDER			= 10
; COLOR_ACTIVECAPTION			= 2
; COLOR_APPWORKSPACE			= 12
; COLOR_BACKGROUND				= 1
; COLOR_BTNFACE					= 15
; COLOR_BTNHIGHLIGHT			= 20
; COLOR_BTNHILIGHT				= 20
; COLOR_BTNSHADOW				= 16
; COLOR_BTNTEXT					= 18
; COLOR_CAPTIONTEXT				= 9
; COLOR_DESKTOP					= 1
; COLOR_GRADIENTACTIVECAPTION	= 27
; COLOR_GRADIENTINACTIVECAPTION	= 28
; COLOR_GRAYTEXT				= 17
; COLOR_HIGHLIGHT				= 13
; COLOR_HIGHLIGHTTEXT			= 14
; COLOR_HOTLIGHT				= 26
; COLOR_INACTIVEBORDER			= 11
; COLOR_INACTIVECAPTION			= 3
; COLOR_INACTIVECAPTIONTEXT		= 19
; COLOR_INFOBK					= 24
; COLOR_INFOTEXT				= 23
; COLOR_MENU					= 4
; COLOR_MENUHILIGHT				= 29
; COLOR_MENUBAR					= 30
; COLOR_MENUTEXT				= 7
; COLOR_SCROLLBAR				= 0
; COLOR_WINDOW					= 5
; COLOR_WINDOWFRAME				= 6
; COLOR_WINDOWTEXT				= 8

SetSysColorToControl(hwnd, SysColor:=15)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	CreateRect( winRect, 0, 0, 0, 0 ) ;is 16 on both 32 and 64
	DllCall( "GetWindowRect", Ptr, hwnd, Ptr, &winRect )
	w := NumGet(winRect, 8, "UInt")  - NumGet(winRect, 0, "UInt")
	h := NumGet(winRect, 12, "UInt") - NumGet(winRect, 4, "UInt")
	bc := DllCall("GetSysColor", "Int", SysColor, "UInt")
	pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
	pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	SetImage(hwnd, hBitmap)
	Gdip_DeleteBrush(pBrushClear)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
	return 0
}



; Function				Gdip_BitmapFromScreen
; Description			Gets a gdi+ bitmap from the screen
;
; Screen				0 = All screens
;						Any numerical value = Just that screen
;						x|y|w|h = Take specific coordinates with a width and height
; Raster				raster operation code
;
; return					If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1:		one or more of x,y,w,h not passed properly
;
; notes					If no raster operation is specified, then SRCCOPY is used to the returned bitmap

Gdip_BitmapFromScreen(Screen:=0, Raster:="")
{
	hhdc := 0
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	if (Screen = 0)
	{
		_x := DllCall( "GetSystemMetrics", "Int", 76 )
		_y := DllCall( "GetSystemMetrics", "Int", 77 )
		_w := DllCall( "GetSystemMetrics", "Int", 78 )
		_h := DllCall( "GetSystemMetrics", "Int", 79 )
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist("ahk_id " Screen)
			return -2
		CreateRect( winRect, 0, 0, 0, 0 ) ;is 16 on both 32 and 64
		DllCall( "GetWindowRect", Ptr, Screen, Ptr, &winRect )
		_w := NumGet(winRect, 8, "UInt")  - NumGet(winRect, 0, "UInt")
		_h := NumGet(winRect, 12, "UInt") - NumGet(winRect, 4, "UInt")
		_x := _y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if IsInteger(Screen)
	{
		M := GetMonitorInfo(Screen)
		_x := M.Left, _y := M.Top, _w := M.Right-M.Left, _h := M.Bottom-M.Top
	}
	else
	{
		S := StrSplit(Screen, "|")
		_x := S[1], _y := S[2], _w := S[3], _h := S[4]
	}

	if (_x = "") || (_y = "") || (_w = "") || (_h = "")
		return -1

	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(_w, _h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, _w, _h, hhdc, _x, _y, Raster)
	ReleaseDC(hhdc)

	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}



; Function				Gdip_BitmapFromHWND
; Description			Uses PrintWindow to get a handle to the specified window and return a bitmap from it
;
; hwnd					handle to the window to get a bitmap from
;
; return				If the function succeeds, the return value is a pointer to a gdi+ bitmap
;
; notes					Window must not be not minimised in order to get a handle to it's client area

Gdip_BitmapFromHWND(hwnd)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	CreateRect( winRect, 0, 0, 0, 0 ) ;is 16 on both 32 and 64
	DllCall( "GetWindowRect", Ptr, hwnd, Ptr, &winRect )
	Width := NumGet(winRect, 8, "UInt") - NumGet(winRect, 0, "UInt")
	Height := NumGet(winRect, 12, "UInt") - NumGet(winRect, 4, "UInt")
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	return pBitmap
}



; Function				CreateRectF
; Description			Creates a RectF object, containing a the coordinates and dimensions of a rectangle
;
; RectF					Name to call the RectF object
; x						x-coordinate of the upper left corner of the rectangle
; y						y-coordinate of the upper left corner of the rectangle
; w						Width of the rectangle
; h						Height of the rectangle
;
; return				No return value

CreateRectF(ByRef RectF, x, y, w, h)
{
	VarSetCapacity(RectF, 16)
	NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}



; Function				CreateRect
; Description			Creates a Rect object, containing a the coordinates and dimensions of a rectangle
;
; RectF		 			Name to call the RectF object
; x						x-coordinate of the upper left corner of the rectangle
; y						y-coordinate of the upper left corner of the rectangle
; w						Width of the rectangle
; h						Height of the rectangle
;
; return				No return value

CreateRect(ByRef Rect, x, y, w, h)
{
	VarSetCapacity(Rect, 16)
	NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}


; Function				CreateSizeF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF					Name to call the SizeF object
; w						w-value for the SizeF object
; h						h-value for the SizeF object
;
; return				No Return value

CreateSizeF(ByRef SizeF, w, h)
{
	VarSetCapacity(SizeF, 8)
	NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")
}


; Function				CreatePointF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF					Name to call the SizeF object
; w						w-value for the SizeF object
; h						h-value for the SizeF object
;
; return				No Return value

CreatePointF(ByRef PointF, x, y)
{
	VarSetCapacity(PointF, 8)
	NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")
}


; Function				CreateDIBSection
; Description			The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
;
; w						width of the bitmap to create
; h						height of the bitmap to create
; hdc					a handle to the device context to use the palette from
; bpp					bits per pixel (32 = ARGB)
; ppvBits				A pointer to a variable that receives a pointer to the location of the DIB bit values
;
; return				returns a DIB. A gdi bitmap
;
; notes					ppvBits will receive the location of the pixels in the DIB

CreateDIBSection(w, h, hdc:="", bpp:=32, ByRef ppvBits:=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)

	NumPut(w, bi, 4, "uint")
	, NumPut(h, bi, 8, "uint")
	, NumPut(40, bi, 0, "uint")
	, NumPut(1, bi, 12, "ushort")
	, NumPut(0, bi, 16, "uInt")
	, NumPut(bpp, bi, 14, "ushort")

	hbm := DllCall("CreateDIBSection"
					, Ptr, hdc2
					, Ptr, &bi
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "uint*", ppvBits
					, Ptr, 0
					, "uint", 0, Ptr)

	if !hdc
		ReleaseDC(hdc2)
	return hbm
}



; Function				PrintWindow
; Description			The PrintWindow function copies a visual window into the specified device context (DC), typically a printer DC
;
; hwnd					A handle to the window that will be copied
; hdc					A handle to the device context
; Flags					Drawing options
;
; return				If the function succeeds, it returns a nonzero value
;
; PW_CLIENTONLY			= 1

PrintWindow(hwnd, hdc, Flags:=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("PrintWindow", Ptr, hwnd, Ptr, hdc, "uint", Flags)
}



; Function				DestroyIcon
; Description			Destroys an icon and frees any memory the icon occupied
;
; hIcon					Handle to the icon to be destroyed. The icon must not be in use
;
; return				If the function succeeds, the return value is nonzero

DestroyIcon(hIcon)
{
	return DllCall("DestroyIcon", A_PtrSize ? "UPtr" : "UInt", hIcon)
}



; Function:				GetIconDimensions
; Description:			Retrieves a given icon/cursor's width and height
;
; hIcon					Pointer to an icon or cursor
; Width					ByRef variable. This variable is set to the icon's width
; Height				ByRef variable. This variable is set to the icon's height
;
; return				If the function succeeds, the return value is zero, otherwise:
;						-1 = Could not retrieve the icon's info. Check A_LastError for extended information
;						-2 = Could not delete the icon's bitmask bitmap
;						-3 = Could not delete the icon's color bitmap

GetIconDimensions(hIcon, ByRef Width, ByRef Height) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	Width := Height := 0

	VarSetCapacity(ICONINFO, size := 16 + 2 * A_PtrSize, 0)

	if !DllCall("user32\GetIconInfo", Ptr, hIcon, Ptr, &ICONINFO)
		return -1

	hbmMask := NumGet(&ICONINFO, 16, Ptr)
	hbmColor := NumGet(&ICONINFO, 16 + A_PtrSize, Ptr)
	VarSetCapacity(BITMAP, size, 0)

	if DllCall("gdi32\GetObject", Ptr, hbmColor, "Int", size, Ptr, &BITMAP)
	{
		Width := NumGet(&BITMAP, 4, "Int")
		Height := NumGet(&BITMAP, 8, "Int")
	}

	if !DllCall("gdi32\DeleteObject", Ptr, hbmMask)
		return -2

	if !DllCall("gdi32\DeleteObject", Ptr, hbmColor)
		return -3

	return 0
}



PaintDesktop(hdc)
{
	return DllCall("PaintDesktop", A_PtrSize ? "UPtr" : "UInt", hdc)
}



CreateCompatibleBitmap(hdc, w, h)
{
	return DllCall("gdi32\CreateCompatibleBitmap", A_PtrSize ? "UPtr" : "UInt", hdc, "int", w, "int", h)
}



; Function				CreateCompatibleDC
; Description			This function creates a memory device context (DC) compatible with the specified device
;
; hdc					Handle to an existing device context
;
; return				returns the handle to a device context or 0 on failure
;
; notes					If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

CreateCompatibleDC(hdc:=0)
{
	return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}



; Function				SelectObject
; Description			The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
;
; hdc					Handle to a DC
; hgdiobj				A handle to the object to be selected into the DC
;
; return				If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
;
; notes					The specified object must have been created by using one of the following functions
;						Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
;						Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
;						Font - CreateFont, CreateFontIndirect
;						Pen - CreatePen, CreatePenIndirect
;						Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
;
; notes					If the selected object is a region and the function succeeds, the return value is one of the following value
;
; SIMPLEREGION			= 2 Region consists of a single rectangle
; COMPLEXREGION			= 3 Region consists of more than one rectangle
; NULLREGION			= 1 Region is empty

SelectObject(hdc, hgdiobj)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
}



; Function				DeleteObject
; Description			This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
;						After the object is deleted, the specified handle is no longer valid
;
; hObject				Handle to a logical pen, brush, font, bitmap, region, or palette to delete
;
; return				Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

DeleteObject(hObject)
{
	return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}



; Function				GetDC
; Description			This function retrieves a handle to a display device context (DC) for the client area of the specified window.
;						The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window.
;
; hwnd					Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen
;
; return				The handle the device context for the specified window's client area indicates success. NULL indicates failure

GetDC(hwnd:=0)
{
	return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}



; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1

GetDCEx(hwnd, flags:=0, hrgnClip:=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("GetDCEx", Ptr, hwnd, Ptr, hrgnClip, "int", flags)
}



; Function				ReleaseDC
; Description			This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
;
; hdc					Handle to the device context to be released
; hwnd					Handle to the window whose device context is to be released
;
; return				1 = released
;						0 = not released
;
; notes					The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
;						An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function.

ReleaseDC(hdc, hwnd:=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
}



; Function				DeleteDC
; Description			The DeleteDC function deletes the specified device context (DC)
;
; hdc					A handle to the device context
;
; return				If the function succeeds, the return value is nonzero
;
; notes					An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

DeleteDC(hdc)
{
	return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}


; Function				Gdip_LibraryVersion
; Description			Get the current library version
;
; return				the library version
;
; notes					This is useful for non compiled programs to ensure that a person doesn't run an old version when testing your scripts

Gdip_LibraryVersion()
{
	return 1.45
}



; Function				Gdip_LibrarySubVersion
; Description			Get the current library sub version
;
; return				the library sub version
;
; notes					This is the sub-version currently maintained by Rseding91
; 					Updated by guest3456 preliminary AHK v2 support
Gdip_LibrarySubVersion()
{
	return 1.54
}



; Function:				Gdip_BitmapFromBRA
; Description: 			Gets a pointer to a gdi+ bitmap from a BRA file
;
; BRAFromMemIn			The variable for a BRA file read to memory
; File					The name of the file, or its number that you would like (This depends on alternate parameter)
; Alternate				Changes whether the File parameter is the file name or its number
;
; return					If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1 = The BRA variable is empty
;						-2 = The BRA has an incorrect header
;						-3 = The BRA has information missing
;						-4 = Could not find file inside the BRA

Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate := 0) {
	pBitmap := ""

	If !(BRAFromMemIn)
		Return -1
	Headers := StrSplit(StrGet(&BRAFromMemIn, 256, "CP0"), "`n")
	Header := StrSplit(Headers.1, "|")
	If (Header.Length() != 4) || (Header.2 != "BRA!")
		Return -2
	_Info := StrSplit(Headers.2, "|")
	If (_Info.Length() != 3)
		Return -3
	OffsetTOC := StrPut(Headers.1, "CP0") + StrPut(Headers.2, "CP0") ;  + 2
	OffsetData := _Info.2
	SearchIndex := Alternate ? 1 : 2
	TOC := StrGet(&BRAFromMemIn + OffsetTOC, OffsetData - OffsetTOC - 1, "CP0")
	RX1 := A_AhkVersion < "2" ? "mi`nO)^" : "mi`n)^"
	Offset := Size := 0
	If RegExMatch(TOC, RX1 . (Alternate ? File "\|.+?" : "\d+\|" . File) . "\|(\d+)\|(\d+)$", FileInfo) {
		Offset := OffsetData + FileInfo.1
		Size := FileInfo.2
	}
	If (Size = 0)
		Return -4
	hData := DllCall("GlobalAlloc", "UInt", 2, "UInt", Size, "UPtr")
	pData := DllCall("GlobalLock", "Ptr", hData, "UPtr")
	DllCall("RtlMoveMemory", "Ptr", pData, "Ptr", &BRAFromMemIn + Offset, "Ptr", Size)
	DllCall("GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", 1, "PtrP", pStream)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream", "Ptr", pStream, "PtrP", pBitmap)
	ObjRelease(pStream)
	Return pBitmap
}



; Function:				Gdip_BitmapFromBase64
; Description:			Creates a bitmap from a Base64 encoded string
;
; Base64				ByRef variable. Base64 encoded string. Immutable, ByRef to avoid performance overhead of passing long strings.
;
; return				If the function succeeds, the return value is a pointer to a bitmap, otherwise:
;						-1 = Could not calculate the length of the required buffer
;						-2 = Could not decode the Base64 encoded string
;						-3 = Could not create a memory stream

Gdip_BitmapFromBase64(ByRef Base64)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	; calculate the length of the buffer needed
	if !(DllCall("crypt32\CryptStringToBinary", Ptr, &Base64, "UInt", 0, "UInt", 0x01, Ptr, 0, "UIntP", DecLen, Ptr, 0, Ptr, 0))
		return -1

	VarSetCapacity(Dec, DecLen, 0)

	; decode the Base64 encoded string
	if !(DllCall("crypt32\CryptStringToBinary", Ptr, &Base64, "UInt", 0, "UInt", 0x01, Ptr, &Dec, "UIntP", DecLen, Ptr, 0, Ptr, 0))
		return -2

	; create a memory stream
	if !(pStream := DllCall("shlwapi\SHCreateMemStream", Ptr, &Dec, "UInt", DecLen, "UPtr"))
		return -3

	DllCall("gdiplus\GdipCreateBitmapFromStreamICM", Ptr, pStream, "PtrP", pBitmap)
	ObjRelease(pStream)

	return pBitmap
}



; Function				Gdip_DrawRectangle
; Description			This function uses a pen to draw the outline of a rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipDrawRectangle", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}



; Function				Gdip_DrawRoundedRectangle
; Description			This function uses a pen to draw the outline of a rounded rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	_E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return _E
}



; Function				Gdip_DrawEllipse
; Description			This function uses a pen to draw the outline of an ellipse into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle the ellipse will be drawn into
; y						y-coordinate of the top left of the rectangle the ellipse will be drawn into
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipDrawEllipse", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}



; Function				Gdip_DrawBezier
; Description			This function uses a pen to draw the outline of a bezier (a weighted curve) into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the bezier
; y1					y-coordinate of the start of the bezier
; x2					x-coordinate of the first arc of the bezier
; y2					y-coordinate of the first arc of the bezier
; x3					x-coordinate of the second arc of the bezier
; y3					y-coordinate of the second arc of the bezier
; x4					x-coordinate of the end of the bezier
; y4					y-coordinate of the end of the bezier
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipDrawBezier"
					, Ptr, pgraphics
					, Ptr, pPen
					, "float", x1
					, "float", y1
					, "float", x2
					, "float", y2
					, "float", x3
					, "float", y3
					, "float", x4
					, "float", y4)
}



; Function				Gdip_DrawArc
; Description			This function uses a pen to draw the outline of an arc into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the arc
; y						y-coordinate of the start of the arc
; w						width of the arc
; h						height of the arc
; StartAngle			specifies the angle between the x-axis and the starting point of the arc
; SweepAngle			specifies the angle between the starting and ending points of the arc
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipDrawArc"
					, Ptr, pGraphics
					, Ptr, pPen
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "float", StartAngle
					, "float", SweepAngle)
}



; Function				Gdip_DrawPie
; Description			This function uses a pen to draw the outline of a pie into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the pie
; y						y-coordinate of the start of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipDrawPie", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}



; Function				Gdip_DrawLine
; Description			This function uses a pen to draw a line into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the line
; y1					y-coordinate of the start of the line
; x2					x-coordinate of the end of the line
; y2					y-coordinate of the end of the line
;
; return				status enumeration. 0 = success

Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipDrawLine"
					, Ptr, pGraphics
					, Ptr, pPen
					, "float", x1
					, "float", y1
					, "float", x2
					, "float", y2)
}



; Function				Gdip_DrawLines
; Description			This function uses a pen to draw a series of joined lines into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success

Gdip_DrawLines(pGraphics, pPen, Points)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	Points := StrSplit(Points, "|")
	VarSetCapacity(PointF, 8*Points.Length())
	for eachPoint, Point in Points
	{
		Coord := StrSplit(Point, ",")
		NumPut(Coord[1], PointF, 8*(A_Index-1), "float"), NumPut(Coord[2], PointF, (8*(A_Index-1))+4, "float")
	}
	return DllCall("gdiplus\GdipDrawLines", Ptr, pGraphics, Ptr, pPen, Ptr, &PointF, "int", Points.Length())
}



; Function				Gdip_FillRectangle
; Description			This function uses a brush to fill a rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipFillRectangle"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h)
}



; Function				Gdip_FillRoundedRectangle
; Description			This function uses a brush to fill a rounded rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	_E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return _E
}



; Function				Gdip_FillPolygon
; Description			This function uses a brush to fill a polygon in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success
;
; notes					Alternate will fill the polygon as a whole, wheras winding will fill each new "segment"
; Alternate 			= 0
; Winding 				= 1

Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode:=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	Points := StrSplit(Points, "|")
	VarSetCapacity(PointF, 8*Points.Length())
	For eachPoint, Point in Points
	{
		Coord := StrSplit(Point, ",")
		NumPut(Coord[1], PointF, 8*(A_Index-1), "float"), NumPut(Coord[2], PointF, (8*(A_Index-1))+4, "float")
	}
	return DllCall("gdiplus\GdipFillPolygon", Ptr, pGraphics, Ptr, pBrush, Ptr, &PointF, "int", Points.Length(), "int", FillMode)
}



; Function				Gdip_FillPie
; Description			This function uses a brush to fill a pie in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the pie
; y						y-coordinate of the top left of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipFillPie"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "float", StartAngle
					, "float", SweepAngle)
}

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h) {
	; Function				Gdip_FillEllipse
	; Description			This function uses a brush to fill an ellipse in the Graphics of a bitmap
	;
	; pGraphics				Pointer to the Graphics of a bitmap
	; pBrush				Pointer to a brush
	; x						x-coordinate of the top left of the ellipse
	; y						y-coordinate of the top left of the ellipse
	; w						width of the ellipse
	; h						height of the ellipse
	;
	; return				status enumeration. 0 = success
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipFillEllipse", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}

Gdip_FillRegion(pGraphics, pBrush, Region) {
	; Function				Gdip_FillRegion
	; Description			This function uses a brush to fill a region in the Graphics of a bitmap
	;
	; pGraphics				Pointer to the Graphics of a bitmap
	; pBrush				Pointer to a brush
	; Region				Pointer to a Region
	;
	; return				status enumeration. 0 = success
	;
	; notes					You can create a region Gdip_CreateRegion() and then add to this
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipFillRegion", Ptr, pGraphics, Ptr, pBrush, Ptr, Region)
}

Gdip_FillPath(pGraphics, pBrush, pPath) {
	; Function				Gdip_FillPath
	; Description			This function uses a brush to fill a path in the Graphics of a bitmap
	;
	; pGraphics				Pointer to the Graphics of a bitmap
	; pBrush				Pointer to a brush
	; Region				Pointer to a Path
	;
	; return				status enumeration. 0 = success
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipFillPath", Ptr, pGraphics, Ptr, pBrush, Ptr, pPath)
}

Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx:="", sy:="", sw:="", sh:="", Matrix:=1) {
; Function				Gdip_DrawImagePointsRect
; Description			This function draws a bitmap into the Graphics of another bitmap and skews it
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; Points				Points passed as x1,y1|x2,y2|x3,y3 (3 points: top left, top right, bottom left) describing the drawing of the bitmap
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	Points := StrSplit(Points, "|")
	VarSetCapacity(PointF, 8*Points.Length())
	For eachPoint, Point in Points
	{
		Coord := StrSplit(Point, ",")
		NumPut(Coord[1], PointF, 8*(A_Index-1), "float"), NumPut(Coord[2], PointF, (8*(A_Index-1))+4, "float")
	}

	if !IsNumber(Matrix)
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		sx := 0, sy := 0
		sw := Gdip_GetImageWidth(pBitmap)
		sh := Gdip_GetImageHeight(pBitmap)
	}

	_E := DllCall("gdiplus\GdipDrawImagePointsRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, Ptr, &PointF
				, "int", Points.Length()
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return _E
}

Gdip_DrawImage(pGraphics, pBitmap, dx:="", dy:="", dw:="", dh:="", sx:="", sy:="", sw:="", sh:="", Matrix:=1) {
	; Function				Gdip_DrawImage
	; Description			This function draws a bitmap into the Graphics of another bitmap
	;
	; pGraphics				Pointer to the Graphics of a bitmap
	; pBitmap				Pointer to a bitmap to be drawn
	; dx					x-coord of destination upper-left corner
	; dy					y-coord of destination upper-left corner
	; dw					width of destination image
	; dh					height of destination image
	; sx					x-coordinate of source upper-left corner
	; sy					y-coordinate of source upper-left corner
	; sw					width of source image
	; sh					height of source image
	; Matrix				a matrix used to alter image attributes when drawing
	;
	; return				status enumeration. 0 = success
	;
	; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
	;						Gdip_DrawImage performs faster
	;						Matrix can be omitted to just draw with no alteration to ARGB
	;						Matrix may be passed as a digit from 0 - 1 to change just transparency
	;						Matrix can be passed as a matrix with any delimiter. For example:
	;						MatrixBright=
	;						(
	;						1.5		|0		|0		|0		|0
	;						0		|1.5	|0		|0		|0
	;						0		|0		|1.5	|0		|0
	;						0		|0		|0		|1		|0
	;						0.05	|0.05	|0.05	|0		|1
	;						)
	;
	; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
	;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
	;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|1|1|1|0|1

	Ptr := A_PtrSize ? "UPtr" : "UInt"

	if !IsNumber(Matrix)
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	_E := DllCall("gdiplus\GdipDrawImageRectRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, "float", dx
				, "float", dy
				, "float", dw
				, "float", dh
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return _E
}

Gdip_SetImageAttributesColorMatrix(Matrix) {
	; Function				Gdip_SetImageAttributesColorMatrix
	; Description			This function creates an image matrix ready for drawing
	;
	; Matrix				a matrix used to alter image attributes when drawing
	;						passed with any delimeter
	;
	; return				returns an image matrix on sucess or 0 if it fails
	;
	; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
	;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
	;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|1|1|1|0|1
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", , 1), "[^\d-\.]+", "|")
	Matrix := StrSplit(Matrix, "|")
	Loop 25
	{
		M := (Matrix[A_Index] != "") ? Matrix[A_Index] : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(M, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", A_PtrSize ? "UPtr*" : "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", Ptr, ImageAttr, "int", 1, "int", 1, Ptr, &ColourMatrix, Ptr, 0, "int", 0)
	return ImageAttr
}

Gdip_GraphicsFromImage(pBitmap) {
; Function				Gdip_GraphicsFromImage
; Description			This function gets the graphics for a bitmap used for drawing functions
;
; pBitmap				Pointer to a bitmap to get the pointer to its graphics
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					a bitmap can be drawn into the graphics of another bitmap
	DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
}

Gdip_GraphicsFromHDC(hdc) {
; Function				Gdip_GraphicsFromHDC
; Description			This function gets the graphics from the handle to a device context
;
; hdc					This is the handle to the device context
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					You can draw a bitmap into the graphics of another bitmap
	pGraphics := ""

	DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
}

Gdip_GetDC(pGraphics) {
; Function				Gdip_GetDC
; Description			This function gets the device context of the passed Graphics
;
; hdc					This is the handle to the device context
;
; return				returns the device context for the graphics of a bitmap
	DllCall("gdiplus\GdipGetDC", A_PtrSize ? "UPtr" : "UInt", pGraphics, A_PtrSize ? "UPtr*" : "UInt*", hdc)
	return hdc
}

Gdip_ReleaseDC(pGraphics, hdc) {
; Function				Gdip_ReleaseDC
; Description			This function releases a device context from use for further use
;
; pGraphics				Pointer to the graphics of a bitmap
; hdc					This is the handle to the device context
;
; return				status enumeration. 0 = success
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipReleaseDC", Ptr, pGraphics, Ptr, hdc)
}

Gdip_GraphicsClear(pGraphics, ARGB:=0x00ffffff) {
; Function				Gdip_GraphicsClear
; Description			Clears the graphics of a bitmap ready for further drawing
;
; pGraphics				Pointer to the graphics of a bitmap
; ARGB					The colour to clear the graphics to
;
; return				status enumeration. 0 = success
;
; notes					By default this will make the background invisible
;						Using clipping regions you can clear a particular area on the graphics rather than clearing the entire graphics
	return DllCall("gdiplus\GdipGraphicsClear", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", ARGB)
}

Gdip_BlurBitmap(pBitmap, Blur) {
; Function				Gdip_BlurBitmap
; Description			Gives a pointer to a blurred bitmap from a pointer to a bitmap
;
; pBitmap				Pointer to a bitmap to be blurred
; Blur					The Amount to blur a bitmap by from 1 (least blur) to 100 (most blur)
;
; return				If the function succeeds, the return value is a pointer to the new blurred bitmap
;						-1 = The blur parameter is outside the range 1-100
;
; notes					This function will not dispose of the original bitmap
	if (Blur > 100) || (Blur < 1)
		return -1

	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

	Gdip_DeleteGraphics(G1)

	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)
	return pBitmap2
}

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality:=75) {
; Function:				Gdip_SaveBitmapToFile
; Description:			Saves a bitmap to a file in any supported format onto disk
;
; pBitmap				Pointer to a bitmap
; sOutput				The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality				If saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return				If the function succeeds, the return value is zero, otherwise:
;						-1 = Extension supplied is not a supported file format
;						-2 = Could not get a list of encoders on system
;						-3 = Could not find matching encoder for specified file format
;						-4 = Could not get WideChar name of output file
;						-5 = Could not save file to disk
;
; notes					This function will use the extension supplied from the sOutput parameter to determine the output format
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	nCount := 0
	nSize := 0
	_p := 0

	SplitPath sOutput,,, Extension
	if !RegExMatch(Extension, "^(?i:BMP|DIB|RLE|JPG|JPEG|JPE|JFIF|GIF|TIF|TIFF|PNG)$")
		return -1
	Extension := "." Extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
	if !(nCount && nSize)
		return -2

	If (A_IsUnicode){
		StrGet_Name := "StrGet"

		N := (A_AhkVersion < 2) ? nCount : "nCount"
		Loop %N%
		{
			sString := %StrGet_Name%(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
			if !InStr(sString, "*" Extension)
				continue

			pCodec := &ci+idx
			break
		}
	} else {
		N := (A_AhkVersion < 2) ? nCount : "nCount"
		Loop %N%
		{
			Location := NumGet(ci, 76*(A_Index-1)+44)
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue

			pCodec := &ci+76*(A_Index-1)
			break
		}
	}

	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if RegExMatch(Extension, "^\.(?i:JPG|JPEG|JPE|JFIF)$")
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
			nCount := NumGet(EncoderParameters, "UInt")
			N := (A_AhkVersion < 2) ? nCount : "nCount"
			Loop %N%
			{
				elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
				if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
				{
					_p := elem+&EncoderParameters-pad-4
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, _p+0)+20, "UInt")), "UInt")
					break
				}
			}
		}
	}

	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		_E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &wOutput, Ptr, pCodec, "uint", _p ? _p : 0)
	}
	else
		_E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &sOutput, Ptr, pCodec, "uint", _p ? _p : 0)
	return _E ? -5 : 0
}

Gdip_GetPixel(pBitmap, x, y) {
	; Function				Gdip_GetPixel
	; Description			Gets the ARGB of a pixel in a bitmap
	;
	; pBitmap				Pointer to a bitmap
	; x						x-coordinate of the pixel
	; y						y-coordinate of the pixel
	;
	; return				Returns the ARGB value of the pixel
	ARGB := 0

	DllCall("gdiplus\GdipBitmapGetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "uint*", ARGB)
	return ARGB
}

Gdip_SetPixel(pBitmap, x, y, ARGB) {
; Function				Gdip_SetPixel
; Description			Sets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				status enumeration. 0 = success
	return DllCall("gdiplus\GdipBitmapSetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "int", ARGB)
}

Gdip_GetImageWidth(pBitmap) {
; Function				Gdip_GetImageWidth
; Description			Gives the width of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the width in pixels of the supplied bitmap
	DllCall("gdiplus\GdipGetImageWidth", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Width)
	return Width
}

Gdip_GetImageHeight(pBitmap) {
	; Function				Gdip_GetImageHeight
	; Description			Gives the height of a bitmap
	;
	; pBitmap				Pointer to a bitmap
	;
	; return				Returns the height in pixels of the supplied bitmap
	DllCall("gdiplus\GdipGetImageHeight", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Height)
	return Height
}



; Function				Gdip_GetDimensions
; Description			Gives the width and height of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Width := 0
	Height := 0
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	DllCall("gdiplus\GdipGetImageWidth", Ptr, pBitmap, "uint*", Width)
	DllCall("gdiplus\GdipGetImageHeight", Ptr, pBitmap, "uint*", Height)
}



Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height) {
	Gdip_GetImageDimensions(pBitmap, Width, Height)
}

Gdip_GetImagePixelFormat(pBitmap) {
	DllCall("gdiplus\GdipGetImagePixelFormat", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", Format)
	return Format
}

Gdip_GetDpiX(pGraphics) {

	;;	Function				Gdip_GetDpiX
	    	; Description			Gives the horizontal dots per inch of the graphics of a bitmap

	    	; pBitmap				Pointer to a bitmap
			; Width					ByRef variable. This variable will be set to the width of the bitmap
			; Height	    			ByRef variable. This variable will be set to the height of the bitmap

			; return	    			No return value
		             					; Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height


	DllCall("gdiplus\GdipGetDpiX", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", dpix)

return Round(dpix)
}

Gdip_GetDpiY(pGraphics) {
	DllCall("gdiplus\GdipGetDpiY", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", dpiy)
	return Round(dpiy)
}

Gdip_GetImageHorizontalResolution(pBitmap) {
	DllCall("gdiplus\GdipGetImageHorizontalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", dpix)
	return Round(dpix)
}

Gdip_GetImageVerticalResolution(pBitmap) {
	DllCall("gdiplus\GdipGetImageVerticalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", dpiy)
	return Round(dpiy)
}

Gdip_BitmapSetResolution(pBitmap, dpix, dpiy) {
	return DllCall("gdiplus\GdipBitmapSetResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float", dpix, "float", dpiy)
}

Gdip_CreateBitmapFromFile(sFile, IconNumber:=1, IconSize:="") {
	pBitmap := ""
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	, PtrA := A_PtrSize ? "UPtr*" : "UInt*"

	SplitPath sFile,,, Extension
	if RegExMatch(Extension, "^(?i:exe|dll)$")
	{
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		BufSize := 16 + (2*(A_PtrSize ? A_PtrSize : 4))

		VarSetCapacity(buf, BufSize, 0)
		For eachSize, Size in StrSplit( Sizes, "|" )
		{
			DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", Size, "int", Size, PtrA, hIcon, PtrA, 0, "uint", 1, "uint", 0)

			if !hIcon
				continue

			if !DllCall("GetIconInfo", Ptr, hIcon, Ptr, &buf)
			{
				DestroyIcon(hIcon)
				continue
			}

			hbmMask  := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4))
			hbmColor := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4) + (A_PtrSize ? A_PtrSize : 4))
			if !(hbmColor && DllCall("GetObject", Ptr, hbmColor, "int", BufSize, Ptr, &buf))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}
		if !hIcon
			return -1

		Width := NumGet(buf, 4, "int"), Height := NumGet(buf, 8, "int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
		if !DllCall("DrawIconEx", Ptr, hdc, "int", 0, "int", 0, Ptr, hIcon, "uint", Width, "uint", Height, "uint", 0, Ptr, 0, "uint", 3)
		{
			DestroyIcon(hIcon)
			return -2
		}

		VarSetCapacity(dib, 104)
		DllCall("GetObject", Ptr, hbm, "int", A_PtrSize = 8 ? 104 : 84, Ptr, &dib) ; sizeof(DIBSECTION) = 76+2*(A_PtrSize=8?4:0)+2*A_PtrSize
		Stride := NumGet(dib, 12, "Int"), Bits := NumGet(dib, 20 + (A_PtrSize = 8 ? 4 : 0)) ; padding
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, Ptr, Bits, PtrA, pBitmapOld)
		pBitmap := Gdip_CreateBitmap(Width, Height)
		_G := Gdip_GraphicsFromImage(pBitmap)
		, Gdip_DrawImage(_G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(_G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)
	}
	else
	{
		if (!A_IsUnicode)
		{
			VarSetCapacity(wFile, 1024)
			DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sFile, "int", -1, Ptr, &wFile, "int", 512)
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &wFile, PtrA, pBitmap)
		}
		else
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &sFile, PtrA, pBitmap)
	}

	return pBitmap
}

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette:=0) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	pBitmap := ""

	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", Ptr, hBitmap, Ptr, Palette, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background:=0xffffffff) {
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", hbm, "int", Background)
	return hbm
}

Gdip_CreateBitmapFromHICON(hIcon) {
	pBitmap := ""

	DllCall("gdiplus\GdipCreateBitmapFromHICON", A_PtrSize ? "UPtr" : "UInt", hIcon, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

Gdip_CreateHICONFromBitmap(pBitmap) {
	pBitmap := ""
	hIcon := 0

	DllCall("gdiplus\GdipCreateHICONFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", hIcon)
	return hIcon
}

Gdip_CreateBitmap(Width, Height, Format:=0x26200A) {
	pBitmap := ""
	DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
Return pBitmap
}

Gdip_CreateBitmapFromClipboard() {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	if !DllCall("OpenClipboard", Ptr, 0)
		return -1
	if !DllCall("IsClipboardFormatAvailable", "uint", 8)
		return -2
	if !hBitmap := DllCall("GetClipboardData", "uint", 2, Ptr)
		return -3
	if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
		return -4
	if !DllCall("CloseClipboard")
		return -5
	DeleteObject(hBitmap)
	return pBitmap
}


Gdip_SetBitmapToClipboard(pBitmap)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	off1 := A_PtrSize = 8 ? 52 : 44, off2 := A_PtrSize = 8 ? 32 : 24
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	DllCall("GetObject", Ptr, hBitmap, "int", VarSetCapacity(oi, A_PtrSize = 8 ? 104 : 84, 0), Ptr, &oi)
	hdib := DllCall("GlobalAlloc", "uint", 2, Ptr, 40+NumGet(oi, off1, "UInt"), Ptr)
	pdib := DllCall("GlobalLock", Ptr, hdib, Ptr)
	DllCall("RtlMoveMemory", Ptr, pdib, Ptr, &oi+off2, Ptr, 40)
	DllCall("RtlMoveMemory", Ptr, pdib+40, Ptr, NumGet(oi, off2 - (A_PtrSize ? A_PtrSize : 4), Ptr), Ptr, NumGet(oi, off1, "UInt"))
	DllCall("GlobalUnlock", Ptr, hdib)
	DllCall("DeleteObject", Ptr, hBitmap)
	DllCall("OpenClipboard", Ptr, 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "uint", 8, Ptr, hdib)
	DllCall("CloseClipboard")
}



Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format:=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea"
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "int", Format
					, A_PtrSize ? "UPtr" : "UInt", pBitmap
					, A_PtrSize ? "UPtr*" : "UInt*", pBitmapDest)
	return pBitmapDest
}


; Create resources


Gdip_CreatePen(ARGB, w)
{
	DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
	return pPen
}



Gdip_CreatePenFromBrush(pBrush, w)
{
	pPen := ""

	DllCall("gdiplus\GdipCreatePen2", A_PtrSize ? "UPtr" : "UInt", pBrush, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
	return pPen
}



Gdip_BrushCreateSolid(ARGB:=0xff000000)
{
	pBrush := ""

	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}



; HatchStyleHorizontal = 0
; HatchStyleVertical = 1
; HatchStyleForwardDiagonal = 2
; HatchStyleBackwardDiagonal = 3
; HatchStyleCross = 4
; HatchStyleDiagonalCross = 5
; HatchStyle05Percent = 6
; HatchStyle10Percent = 7
; HatchStyle20Percent = 8
; HatchStyle25Percent = 9
; HatchStyle30Percent = 10
; HatchStyle40Percent = 11
; HatchStyle50Percent = 12
; HatchStyle60Percent = 13
; HatchStyle70Percent = 14
; HatchStyle75Percent = 15
; HatchStyle80Percent = 16
; HatchStyle90Percent = 17
; HatchStyleLightDownwardDiagonal = 18
; HatchStyleLightUpwardDiagonal = 19
; HatchStyleDarkDownwardDiagonal = 20
; HatchStyleDarkUpwardDiagonal = 21
; HatchStyleWideDownwardDiagonal = 22
; HatchStyleWideUpwardDiagonal = 23
; HatchStyleLightVertical = 24
; HatchStyleLightHorizontal = 25
; HatchStyleNarrowVertical = 26
; HatchStyleNarrowHorizontal = 27
; HatchStyleDarkVertical = 28
; HatchStyleDarkHorizontal = 29
; HatchStyleDashedDownwardDiagonal = 30
; HatchStyleDashedUpwardDiagonal = 31
; HatchStyleDashedHorizontal = 32
; HatchStyleDashedVertical = 33
; HatchStyleSmallConfetti = 34
; HatchStyleLargeConfetti = 35
; HatchStyleZigZag = 36
; HatchStyleWave = 37
; HatchStyleDiagonalBrick = 38
; HatchStyleHorizontalBrick = 39
; HatchStyleWeave = 40
; HatchStylePlaid = 41
; HatchStyleDivot = 42
; HatchStyleDottedGrid = 43
; HatchStyleDottedDiamond = 44
; HatchStyleShingle = 45
; HatchStyleTrellis = 46
; HatchStyleSphere = 47
; HatchStyleSmallGrid = 48
; HatchStyleSmallCheckerBoard = 49
; HatchStyleLargeCheckerBoard = 50
; HatchStyleOutlinedDiamond = 51
; HatchStyleSolidDiamond = 52
; HatchStyleTotal = 53
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle:=0)
{
	pBrush := ""

	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}



Gdip_CreateTextureBrush(pBitmap, WrapMode:=1, x:=0, y:=0, w:="", h:="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	, PtrA := A_PtrSize ? "UPtr*" : "UInt*"

	if !(w && h)
		DllCall("gdiplus\GdipCreateTexture", Ptr, pBitmap, "int", WrapMode, PtrA, pBrush)
	else
		DllCall("gdiplus\GdipCreateTexture2", Ptr, pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, PtrA, pBrush)
	return pBrush
}



; WrapModeTile = 0
; WrapModeTileFlipX = 1
; WrapModeTileFlipY = 2
; WrapModeTileFlipXY = 3
; WrapModeClamp = 4
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode:=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", Ptr, &PointF1, Ptr, &PointF2, "Uint", ARGB1, "Uint", ARGB2, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}



; LinearGradientModeHorizontal = 0
; LinearGradientModeVertical = 1
; LinearGradientModeForwardDiagonal = 2
; LinearGradientModeBackwardDiagonal = 3
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode:=1, WrapMode:=1) {
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", A_PtrSize ? "UPtr" : "UInt", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}

Gdip_CloneBrush(pBrush) {
	DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, A_PtrSize ? "UPtr*" : "UInt*", pBrushClone)
	return pBrushClone
}

; Delete resources
Gdip_DeletePen(pPen) {
	return DllCall("gdiplus\GdipDeletePen", A_PtrSize ? "UPtr" : "UInt", pPen)
}

Gdip_DeleteBrush(pBrush) {
	return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
}

Gdip_DisposeImage(pBitmap) {
	return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}

Gdip_DeleteGraphics(pGraphics) {
	return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

Gdip_DisposeImageAttributes(ImageAttr) {
	return DllCall("gdiplus\GdipDisposeImageAttributes", A_PtrSize ? "UPtr" : "UInt", ImageAttr)
}

Gdip_DeleteFont(hFont) {
	return DllCall("gdiplus\GdipDeleteFont", A_PtrSize ? "UPtr" : "UInt", hFont)
}

Gdip_DeleteStringFormat(hFormat) {
	return DllCall("gdiplus\GdipDeleteStringFormat", A_PtrSize ? "UPtr" : "UInt", hFormat)
}

Gdip_DeleteFontFamily(hFamily) {
	return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
}

Gdip_DeleteMatrix(Matrix) {
	return DllCall("gdiplus\GdipDeleteMatrix", A_PtrSize ? "UPtr" : "UInt", Matrix)
}

; Text functions
Gdip_TextToGraphics(pGraphics, Text, Options, Font:="Arial", Width:="", Height:="", Measure:=0) {
	IWidth := Width, IHeight:= Height

	pattern_opts := (A_AhkVersion < "2") ? "iO)" : "i)"
	RegExMatch(Options, pattern_opts "X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, pattern_opts "Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, pattern_opts "W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, pattern_opts "H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, pattern_opts "C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, pattern_opts "Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, pattern_opts "NoWrap", NoWrap)
	RegExMatch(Options, pattern_opts "R(\d)", Rendering)
	RegExMatch(Options, pattern_opts "S(\d+)(p*)", Size)

	if Colour && !Gdip_DeleteBrush(Gdip_CloneBrush(Colour[2]))
		PassBrush := 1, pBrush := Colour[2]

	if !(IWidth && IHeight) && ((xpos && xpos[2]) || (ypos && ypos[2]) || (Width && Width[2]) || (Height && Height[2]) || (Size && Size[2]))
		return -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	For eachStyle, valStyle in StrSplit( Styles, "|" )
	{
		if RegExMatch(Options, "\b" valStyle)
			Style |= (valStyle != "StrikeOut") ? (A_Index-1) : 8
	}

	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	For eachAlignment, valAlignment in StrSplit( Alignments, "|" )
	{
		if RegExMatch(Options, "\b" valAlignment)
			Align |= A_Index//2.1	; 0|0|1|1|2|2
	}

	xpos := (xpos && (xpos[1] != "")) ? xpos[2] ? IWidth*(xpos[1]/100) : xpos[1] : 0
	ypos := (ypos && (ypos[1] != "")) ? ypos[2] ? IHeight*(ypos[1]/100) : ypos[1] : 0
	Width := (Width && Width[1]) ? Width[2] ? IWidth*(Width[1]/100) : Width[1] : IWidth
	Height := (Height && Height[1]) ? Height[2] ? IHeight*(Height[1]/100) : Height[1] : IHeight
	if !PassBrush
		Colour := "0x" (Colour && Colour[2] ? Colour[2] : "ff000000")
	Rendering := (Rendering && (Rendering[1] >= 0) && (Rendering[1] <= 5)) ? Rendering[1] : 4
	Size := (Size && (Size[1] > 0)) ? Size[2] ? IHeight*(Size[1]/100) : Size[1] : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0

	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	if vPos
	{
		ReturnRC := StrSplit(ReturnRC, "|")

		if (vPos[0] = "vCentre") || (vPos[0] = "vCenter")
			ypos += (Height-ReturnRC[4])//2
		else if (vPos[0] = "Top") || (vPos[0] = "Up")
			ypos := 0
		else if (vPos[0] = "Bottom") || (vPos[0] = "Down")
			ypos := Height-ReturnRC[4]

		CreateRectF(RC, xpos, ypos, Width, ReturnRC[4])
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		_E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return _E ? _E : ReturnRC
}

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}

	return DllCall("gdiplus\GdipDrawString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, pBrush)
}

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)  {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}

	DllCall("gdiplus\GdipMeasureString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, &RC
					, "uint*", Chars
					, "uint*", Lines)

	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}

Gdip_SetStringFormatAlign(hFormat, Align) {
	; Near = 0
	; Center = 1
	; Far = 2
	return DllCall("gdiplus\GdipSetStringFormatAlign", A_PtrSize ? "UPtr" : "UInt", hFormat, "int", Align)
}

Gdip_StringFormatCreate(Format:=0, Lang:=0) {
	; StringFormatFlagsDirectionRightToLeft    = 0x00000001
	; StringFormatFlagsDirectionVertical       = 0x00000002
	; StringFormatFlagsNoFitBlackBox           = 0x00000004
	; StringFormatFlagsDisplayFormatControl    = 0x00000020
	; StringFormatFlagsNoFontFallback          = 0x00000400
	; StringFormatFlagsMeasureTrailingSpaces   = 0x00000800
	; StringFormatFlagsNoWrap                  = 0x00001000
	; StringFormatFlagsLineLimit               = 0x00002000
	; StringFormatFlagsNoClip                  = 0x00004000
	DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, A_PtrSize ? "UPtr*" : "UInt*", hFormat)
	return hFormat
}

Gdip_FontCreate(hFamily, Size, Style:=0) {
	; Regular = 0
	; Bold = 1
	; Italic = 2
	; BoldItalic = 3
	; Underline = 4
	; Strikeout = 8
	DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size, "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", hFont)
	return hFont
}

Gdip_FontFamilyCreate(Font) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, Ptr, &wFont, "int", nSize)
	}

	DllCall("gdiplus\GdipCreateFontFamilyFromName"
					, Ptr, A_IsUnicode ? &Font : &wFont
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "UInt*", hFamily)

	return hFamily
}

; Matrix functions
Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y) {
	DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, A_PtrSize ? "UPtr*" : "UInt*", Matrix)
	return Matrix
}

Gdip_CreateMatrix() {
	DllCall("gdiplus\GdipCreateMatrix", A_PtrSize ? "UPtr*" : "UInt*", Matrix)
	return Matrix
}

; GraphicsPath functions
Gdip_CreatePath(BrushMode:=0) {
	; Alternate = 0
	; Winding = 1
	DllCall("gdiplus\GdipCreatePath", "int", BrushMode, A_PtrSize ? "UPtr*" : "UInt*", pPath)
	return pPath
}

Gdip_AddPathEllipse(pPath, x, y, w, h) {
	return DllCall("gdiplus\GdipAddPathEllipse", A_PtrSize ? "UPtr" : "UInt", pPath, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathPolygon(pPath, Points) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	Points := StrSplit(Points, "|")
	VarSetCapacity(PointF, 8*Points.Length())
	for eachPoint, Point in Points
	{
		Coord := StrSplit(Point, ",")
		NumPut(Coord[1], PointF, 8*(A_Index-1), "float"), NumPut(Coord[2], PointF, (8*(A_Index-1))+4, "float")
	}

	return DllCall("gdiplus\GdipAddPathPolygon", Ptr, pPath, Ptr, &PointF, "int", Points.Length())
}

Gdip_DeletePath(pPath) {
	return DllCall("gdiplus\GdipDeletePath", A_PtrSize ? "UPtr" : "UInt", pPath)
}

; Quality functions
Gdip_SetTextRenderingHint(pGraphics, RenderingHint) {
	; SystemDefault = 0
	; SingleBitPerPixelGridFit = 1
	; SingleBitPerPixel = 2
	; AntiAliasGridFit = 3
	; AntiAlias = 4
	return DllCall("gdiplus\GdipSetTextRenderingHint", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", RenderingHint)
}

Gdip_SetInterpolationMode(pGraphics, InterpolationMode) {
	; Default = 0
	; LowQuality = 1
	; HighQuality = 2
	; Bilinear = 3
	; Bicubic = 4
	; NearestNeighbor = 5
	; HighQualityBilinear = 6
	; HighQualityBicubic = 7
	return DllCall("gdiplus\GdipSetInterpolationMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", InterpolationMode)
}

Gdip_SetSmoothingMode(pGraphics, SmoothingMode) {
	; Default = 0
	; HighSpeed = 1
	; HighQuality = 2
	; None = 3
	; AntiAlias = 4
	return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
}

Gdip_SetCompositingMode(pGraphics, CompositingMode:=0) {
	; CompositingModeSourceOver = 0 (blended)
	; CompositingModeSourceCopy = 1 (overwrite)
	return DllCall("gdiplus\GdipSetCompositingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", CompositingMode)
}

; Extra functions
Gdip_Startup() {
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	pToken := 0

	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}

Gdip_Shutdown(pToken) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}

Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder:=0) {
	; Prepend = 0; The new operation is applied before the old operation.
	; Append = 1; The new operation is applied after the old operation.
	return DllCall("gdiplus\GdipRotateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder:=0) {
	return DllCall("gdiplus\GdipScaleWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder:=0) {
	return DllCall("gdiplus\GdipTranslateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_ResetWorldTransform(pGraphics) {
	return DllCall("gdiplus\GdipResetWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation) {
	pi := 3.14159, TAngle := Angle*(pi/180)

	Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
	if ((Bound >= 0) && (Bound <= 90))
		xTranslation := Height*Sin(TAngle), yTranslation := 0
	else if ((Bound > 90) && (Bound <= 180))
		xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
	else if ((Bound > 180) && (Bound <= 270))
		xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
	else if ((Bound > 270) && (Bound <= 360))
		xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight) {
	pi := 3.14159, TAngle := Angle*(pi/180)
	if !(Width && Height)
		return -1
	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

Gdip_ImageRotateFlip(pBitmap, RotateFlipType:=1) {
	; RotateNoneFlipNone   = 0
	; Rotate90FlipNone     = 1
	; Rotate180FlipNone    = 2
	; Rotate270FlipNone    = 3
	; RotateNoneFlipX      = 4
	; Rotate90FlipX        = 5
	; Rotate180FlipX       = 6
	; Rotate270FlipX       = 7
	; RotateNoneFlipY      = Rotate180FlipX
	; Rotate90FlipY        = Rotate270FlipX
	; Rotate180FlipY       = RotateNoneFlipX
	; Rotate270FlipY       = Rotate90FlipX
	; RotateNoneFlipXY     = Rotate180FlipNone
	; Rotate90FlipXY       = Rotate270FlipNone
	; Rotate180FlipXY      = RotateNoneFlipNone
	; Rotate270FlipXY      = Rotate90FlipNone
	return DllCall("gdiplus\GdipImageRotateFlip", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", RotateFlipType)
}

Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode:=0) {
	; Replace = 0
	; Intersect = 1
	; Union = 2
	; Xor = 3
	; Exclude = 4
	; Complement = 5
	return DllCall("gdiplus\GdipSetClipRect",  A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}

Gdip_SetClipPath(pGraphics, pPath, CombineMode:=0) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipSetClipPath", Ptr, pGraphics, Ptr, pPath, "int", CombineMode)
}

Gdip_ResetClip(pGraphics) {
	return DllCall("gdiplus\GdipResetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

Gdip_GetClipRegion(pGraphics) {
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics, "UInt", Region)
	return Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode:=0) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("gdiplus\GdipSetClipRegion", Ptr, pGraphics, Ptr, Region, "int", CombineMode)
}

Gdip_CreateRegion() {
	DllCall("gdiplus\GdipCreateRegion", "UInt*", Region)
	return Region
}

Gdip_DeleteRegion(Region) {
	return DllCall("gdiplus\GdipDeleteRegion", A_PtrSize ? "UPtr" : "UInt", Region)
}

; BitmapLockBits
Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode := 3, PixelFormat := 0x26200a) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	CreateRect(_Rect, x, y, w, h)
	VarSetCapacity(BitmapData, 16+2*(A_PtrSize ? A_PtrSize : 4), 0)
	_E := DllCall("Gdiplus\GdipBitmapLockBits", Ptr, pBitmap, Ptr, &_Rect, "uint", LockMode, "int", PixelFormat, Ptr, &BitmapData)
	Stride := NumGet(BitmapData, 8, "Int")
	Scan0 := NumGet(BitmapData, 16, Ptr)
	return _E
}

Gdip_UnlockBits(pBitmap, ByRef BitmapData) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	return DllCall("Gdiplus\GdipBitmapUnlockBits", Ptr, pBitmap, Ptr, &BitmapData)
}

Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride) {
	Numput(ARGB, Scan0+0, (x*4)+(y*Stride), "UInt")
}

Gdip_GetLockBitPixel(Scan0, x, y, Stride) {
	return NumGet(Scan0+0, (x*4)+(y*Stride), "UInt")
}

Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize) {
	static PixelateBitmap

	Ptr := A_PtrSize ? "UPtr" : "UInt"

	if (!PixelateBitmap)
	{
		if A_PtrSize != 8 ; x86 machine code
		MCode_PixelateBitmap := "
		(LTrim Join
		558BEC83EC3C8B4514538B5D1C99F7FB56578BC88955EC894DD885C90F8E830200008B451099F7FB8365DC008365E000894DC88955F08945E833FF897DD4
		397DE80F8E160100008BCB0FAFCB894DCC33C08945F88945FC89451C8945143BD87E608B45088D50028BC82BCA8BF02BF2418945F48B45E02955F4894DC4
		8D0CB80FAFCB03CA895DD08BD1895DE40FB64416030145140FB60201451C8B45C40FB604100145FC8B45F40FB604020145F883C204FF4DE475D6034D18FF
		4DD075C98B4DCC8B451499F7F98945148B451C99F7F989451C8B45FC99F7F98945FC8B45F899F7F98945F885DB7E648B450C8D50028BC82BCA83C103894D
		C48BC82BCA41894DF48B4DD48945E48B45E02955E48D0C880FAFCB03CA895DD08BD18BF38A45148B7DC48804178A451C8B7DF488028A45FC8804178A45F8
		8B7DE488043A83C2044E75DA034D18FF4DD075CE8B4DCC8B7DD447897DD43B7DE80F8CF2FEFFFF837DF0000F842C01000033C08945F88945FC89451C8945
		148945E43BD87E65837DF0007E578B4DDC034DE48B75E80FAF4D180FAFF38B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945CC0F
		B6440E030145140FB60101451C0FB6440F010145FC8B45F40FB604010145F883C104FF4DCC75D8FF45E4395DE47C9B8B4DF00FAFCB85C9740B8B451499F7
		F9894514EB048365140033F63BCE740B8B451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB
		038975F88975E43BDE7E5A837DF0007E4C8B4DDC034DE48B75E80FAF4D180FAFF38B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955CC8A55
		1488540E038A551C88118A55FC88540F018A55F888140183C104FF4DCC75DFFF45E4395DE47CA68B45180145E0015DDCFF4DC80F8594FDFFFF8B451099F7
		FB8955F08945E885C00F8E450100008B45EC0FAFC38365DC008945D48B45E88945CC33C08945F88945FC89451C8945148945103945EC7E6085DB7E518B4D
		D88B45080FAFCB034D108D50020FAF4D18034DDC8BF08BF88945F403CA2BF22BFA2955F4895DC80FB6440E030145140FB60101451C0FB6440F010145FC8B
		45F40FB604080145F883C104FF4DC875D8FF45108B45103B45EC7CA08B4DD485C9740B8B451499F7F9894514EB048365140033F63BCE740B8B451C99F7F9
		89451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975103975EC7E5585DB7E468B4DD88B450C
		0FAFCB034D108D50020FAF4D18034DDC8BF08BF803CA2BF22BFA2BC2895DC88A551488540E038A551C88118A55FC88540F018A55F888140183C104FF4DC8
		75DFFF45108B45103B45EC7CAB8BC3C1E0020145DCFF4DCC0F85CEFEFFFF8B4DEC33C08945F88945FC89451C8945148945103BC87E6C3945F07E5C8B4DD8
		8B75E80FAFCB034D100FAFF30FAF4D188B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945C80FB6440E030145140FB60101451C0F
		B6440F010145FC8B45F40FB604010145F883C104FF4DC875D833C0FF45108B4DEC394D107C940FAF4DF03BC874068B451499F7F933F68945143BCE740B8B
		451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975083975EC7E63EB0233F639
		75F07E4F8B4DD88B75E80FAFCB034D080FAFF30FAF4D188B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955108A551488540E038A551C8811
		8A55FC88540F018A55F888140883C104FF4D1075DFFF45088B45083B45EC7C9F5F5E33C05BC9C21800
		)"
		else ; x64 machine code
		MCode_PixelateBitmap := "
		(LTrim Join
		4489442418488954241048894C24085355565741544155415641574883EC28418BC1448B8C24980000004C8BDA99488BD941F7F9448BD0448BFA8954240C
		448994248800000085C00F8E9D020000418BC04533E4458BF299448924244C8954241041F7F933C9898C24980000008BEA89542404448BE889442408EB05
		4C8B5C24784585ED0F8E1A010000458BF1418BFD48897C2418450FAFF14533D233F633ED4533E44533ED4585C97E5B4C63BC2490000000418D040A410FAF
		C148984C8D441802498BD9498BD04D8BD90FB642010FB64AFF4403E80FB60203E90FB64AFE4883C2044403E003F149FFCB75DE4D03C748FFCB75D0488B7C
		24188B8C24980000004C8B5C2478418BC59941F7FE448BE8418BC49941F7FE448BE08BC59941F7FE8BE88BC69941F7FE8BF04585C97E4048639C24900000
		004103CA4D8BC1410FAFC94863C94A8D541902488BCA498BC144886901448821408869FF408871FE4883C10448FFC875E84803D349FFC875DA8B8C249800
		0000488B5C24704C8B5C24784183C20448FFCF48897C24180F850AFFFFFF8B6C2404448B2424448B6C24084C8B74241085ED0F840A01000033FF33DB4533
		DB4533D24533C04585C97E53488B74247085ED7E42438D0C04418BC50FAF8C2490000000410FAFC18D04814863C8488D5431028BCD0FB642014403D00FB6
		024883C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC17CB28BCD410FAFC985C9740A418BC299F7F98BF0EB0233F685C9740B418BC3
		99F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585C97E4D4C8B74247885ED7E3841
		8D0C14418BC50FAF8C2490000000410FAFC18D04814863C84A8D4431028BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2413BD17CBD
		4C8B7424108B8C2498000000038C2490000000488B5C24704503E149FFCE44892424898C24980000004C897424100F859EFDFFFF448B7C240C448B842480
		000000418BC09941F7F98BE8448BEA89942498000000896C240C85C00F8E3B010000448BAC2488000000418BCF448BF5410FAFC9898C248000000033FF33
		ED33F64533DB4533D24533C04585FF7E524585C97E40418BC5410FAFC14103C00FAF84249000000003C74898488D541802498BD90FB642014403D00FB602
		4883C2044403D80FB642FB03F00FB642FA03E848FFCB75DE488B5C247041FFC0453BC77CAE85C9740B418BC299F7F9448BE0EB034533E485C9740A418BC3
		99F7F98BD8EB0233DB85C9740A8BC699F7F9448BD8EB034533DB85C9740A8BC599F7F9448BD0EB034533D24533C04585FF7E4E488B4C24784585C97E3541
		8BC5410FAFC14103C00FAF84249000000003C74898488D540802498BC144886201881A44885AFF448852FE4883C20448FFC875E941FFC0453BC77CBE8B8C
		2480000000488B5C2470418BC1C1E00203F849FFCE0F85ECFEFFFF448BAC24980000008B6C240C448BA4248800000033FF33DB4533DB4533D24533C04585
		FF7E5A488B7424704585ED7E48418BCC8BC5410FAFC94103C80FAF8C2490000000410FAFC18D04814863C8488D543102418BCD0FB642014403D00FB60248
		83C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC77CAB418BCF410FAFCD85C9740A418BC299F7F98BF0EB0233F685C9740B418BC399
		F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585FF7E4E4585ED7E42418BCC8BC541
		0FAFC903CA0FAF8C2490000000410FAFC18D04814863C8488B442478488D440102418BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2
		413BD77CB233C04883C428415F415E415D415C5F5E5D5BC3
		)"

		VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
		nCount := StrLen(MCode_PixelateBitmap)//2
		N := (A_AhkVersion < 2) ? nCount : "nCount"
		Loop %N%
			NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "UChar")
		DllCall("VirtualProtect", Ptr, &PixelateBitmap, Ptr, VarSetCapacity(PixelateBitmap), "uint", 0x40, A_PtrSize ? "UPtr*" : "UInt*", 0)
	}

	Gdip_GetImageDimensions(pBitmap, Width, Height)

	if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
		return -1
	if (BlockSize > Width || BlockSize > Height)
		return -2

	E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
	if (E1 || E2)
		return -3

	; E := - unused exit code
	DllCall(&PixelateBitmap, Ptr, Scan01, Ptr, Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)

	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
	return 0
}

Gdip_ToARGB(A, R, G, B) {
	return (A << 24) | (R << 16) | (G << 8) | B
}

Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B) {
	A := (0xff000000 & ARGB) >> 24
	R := (0x00ff0000 & ARGB) >> 16
	G := (0x0000ff00 & ARGB) >> 8
	B := 0x000000ff & ARGB
}

Gdip_AFromARGB(ARGB) {
	return (0xff000000 & ARGB) >> 24
}

Gdip_RFromARGB(ARGB) {
	return (0x00ff0000 & ARGB) >> 16
}

Gdip_GFromARGB(ARGB) {
	return (0x0000ff00 & ARGB) >> 8
}

Gdip_BFromARGB(ARGB) {
	return 0x000000ff & ARGB
}

StrGetB(Address, Length:=-1, Encoding:=0) {
	; Flexible parameter handling:
	if !IsInteger(Length)
		Encoding := Length,  Length := -1

	; Check for obvious errors.
	if (Address+0 < 1024)
		return

	; Ensure 'Encoding' contains a numeric identifier.
	if (Encoding = "UTF-16")
		Encoding := 1200
	else if (Encoding = "UTF-8")
		Encoding := 65001
	else if SubStr(Encoding,1,2)="CP"
		Encoding := SubStr(Encoding,3)

	if !Encoding ; "" or 0
	{
		; No conversion necessary, but we might not want the whole string.
		if (Length == -1)
			Length := DllCall("lstrlen", "uint", Address)
		VarSetCapacity(String, Length)
		DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
	}
	else if (Encoding = 1200) ; UTF-16
	{
		char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
		VarSetCapacity(String, char_count)
		DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
	}
	else if IsInteger(Encoding)
	{
		; Convert from target encoding to UTF-16 then to the active code page.
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
		VarSetCapacity(String, char_count * 2)
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", &String, "int", char_count * 2)
		String := StrGetB(&String, char_count, 1200)
	}

	return String
}

; in AHK v1: uses normal 'if var is' command
; in AHK v2: all if's are expression-if, so the Integer variable is dereferenced to the string
IsInteger(Var) {
	Static Integer := "Integer"
	If Var Is Integer
		Return True
	Return False
}

IsNumber(Var) {
	Static number := "number"
	If Var Is number
		Return True
	Return False
}

; ======================================================================================================================
; Multiple Display Monitors Functions -> msdn.microsoft.com/en-us/library/dd145072(v=vs.85).aspx
; by 'just me'
; https://autohotkey.com/boards/viewtopic.php?f=6&t=4606
; ======================================================================================================================
GetMonitorCount() {
	Monitors := MDMF_Enum()
	for k,v in Monitors
		count := A_Index
	return count
}

GetMonitorInfo(MonitorNum) {
	Monitors := MDMF_Enum()
	for k,v in Monitors
		if (v.Num = MonitorNum)
			return v
}

GetPrimaryMonitor() {
	Monitors := MDMF_Enum()
	for k,v in Monitors
		If (v.Primary)
			return v.Num
}

MDMF_Enum(HMON := "") {	                                               	; Enumerates display monitors and returns an object containing the properties of all monitors or the specified monitor.
	Static CbFunc := (A_AhkVersion < "2") ? Func("RegisterCallback") : Func("CallbackCreate")
	Static EnumProc := %CbFunc%("MDMF_EnumProc")
	Static Monitors := {}
	If (HMON = "") ; new enumeration
		Monitors := {}
	If (Monitors.MaxIndex() = "") ; enumerate
		If !DllCall("User32.dll\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", EnumProc, "Ptr", &Monitors, "UInt")
			Return False
	Return (HMON = "") ? Monitors : Monitors.HasKey(HMON) ? Monitors[HMON] : False
}

MDMF_EnumProc(HMON, HDC, PRECT, ObjectAddr) {			;  Callback function that is called by the MDMF_Enum function.
	Monitors := Object(ObjectAddr)
	Monitors[HMON] := MDMF_GetInfo(HMON)
	Return True
}

MDMF_FromHWND(HWND) {													;  Retrieves the display monitor that has the largest area of intersection with a specified window.
	Return DllCall("User32.dll\MonitorFromWindow", "Ptr", HWND, "UInt", 0, "UPtr")
}

MDMF_FromPoint(X := "", Y := "") {											; Retrieves the display monitor that contains a specified point.
; If either X or Y is empty, the function will use the current cursor position for this value.
	VarSetCapacity(PT, 8, 0)
	If (X = "") || (Y = "") {
		DllCall("User32.dll\GetCursorPos", "Ptr", &PT)
		If (X = "")
			X := NumGet(PT, 0, "Int")
		If (Y = "")
			Y := NumGet(PT, 4, "Int")
	}
	Return DllCall("User32.dll\MonitorFromPoint", "Int64", (X & 0xFFFFFFFF) | (Y << 32), "UInt", 0, "UPtr")
}

MDMF_FromRect(X, Y, W, H) {													; Retrieves the display monitor that has the largest area of intersection with a specified rectangle.
; Parameters are consistent with the common AHK definition of a rectangle, which is X, Y, W, H instead of
; Left, Top, Right, Bottom.

	VarSetCapacity(RC, 16, 0)
	NumPut(X, RC, 0, "Int"), NumPut(Y, RC, 4, Int), NumPut(X + W, RC, 8, "Int"), NumPut(Y + H, RC, 12, "Int")
	Return DllCall("User32.dll\MonitorFromRect", "Ptr", &RC, "UInt", 0, "UPtr")
}

MDMF_GetInfo(HMON) {														; Retrieves information about a display monitor.
	NumPut(VarSetCapacity(MIEX, 40 + (32 << !!A_IsUnicode)), MIEX, 0, "UInt")
	If DllCall("User32.dll\GetMonitorInfo", "Ptr", HMON, "Ptr", &MIEX) {
		MonName := StrGet(&MIEX + 40, 32)	; CCHDEVICENAME = 32
		MonNum := RegExReplace(MonName, ".*(\d+)$", "$1")
		Return {	Name:		(Name := StrGet(&MIEX + 40, 32))
				,	Num:		RegExReplace(Name, ".*(\d+)$", "$1")
				,	Left:		NumGet(MIEX, 4, "Int")		; display rectangle
				,	Top:		NumGet(MIEX, 8, "Int")		; "
				,	Right:		NumGet(MIEX, 12, "Int")		; "
				,	Bottom:		NumGet(MIEX, 16, "Int")		; "
				,	WALeft:		NumGet(MIEX, 20, "Int")		; work area
				,	WATop:		NumGet(MIEX, 24, "Int")		; "
				,	WARight:	NumGet(MIEX, 28, "Int")		; "
				,	WABottom:	NumGet(MIEX, 32, "Int")		; "
				,	Primary:	NumGet(MIEX, 36, "UInt")}	; contains a non-zero value for the primary monitor.
	}
	Return False
}












;------------------------------
;
; Function: AddTooltip v2.0
;
; Description:
;
;   Add/Update tooltips to GUI controls.
;
; Parameters:
;
;   p1 - Handle to a GUI control.  Alternatively, set to "Activate" to enable
;       the tooltip control, "AutoPopDelay" to set the autopop delay time,
;       "Deactivate" to disable the tooltip control, or "Title" to set the
;       tooltip title.
;
;   p2 - If p1 contains the handle to a GUI control, this parameter should
;       contain the tooltip text.  Ex: "My tooltip".  Set to null to delete the
;       tooltip attached to the control.  If p1="AutoPopDelay", set to the
;       desired autopop delay time, in seconds.  Ex: 10.  Note: The maximum
;       autopop delay time is ~32 seconds.  If p1="Title", set to the title of
;       the tooltip.  Ex: "Bob's Tooltips".  Set to null to remove the tooltip
;       title.  See the *Title & Icon* section for more information.
;
;   p3 - Tooltip icon.  See the *Title & Icon* section for more information.
;
; Returns:
;
;   The handle to the tooltip control.
;
; Requirements:
;
;   AutoHotkey v1.1+ (all versions).
;
; Title & Icon:
;
;   To set the tooltip title, set the p1 parameter to "Title" and the p2
;   parameter to the desired tooltip title.  Ex: AddTooltip("Title","Bob's
;   Tooltips"). To remove the tooltip title, set the p2 parameter to null.  Ex:
;   AddTooltip("Title","").
;
;   The p3 parameter determines the icon to be displayed along with the title,
;   if any.  If not specified or if set to 0, no icon is shown.  To show a
;   standard icon, specify one of the standard icon identifiers.  See the
;   function's static variables for a list of possible values.  Ex:
;   AddTooltip("Title","My Title",4).  To show a custom icon, specify a handle
;   to an image (bitmap, cursor, or icon).  When a custom icon is specified, a
;   copy of the icon is created by the tooltip window so if needed, the original
;   icon can be destroyed any time after the title and icon are set.
;
;   Setting a tooltip title may not produce a desirable result in many cases.
;   The title (and icon if specified) will be shown on every tooltip that is
;   added by this function.
;
; Remarks:
;
;   The tooltip control is enabled by default.  There is no need to "Activate"
;   the tooltip control unless it has been previously "Deactivated".
;
;   This function returns the handle to the tooltip control so that, if needed,
;   additional actions can be performed on the Tooltip control outside of this
;   function.  Once created, this function reuses the same tooltip control.
;   If the tooltip control is destroyed outside of this function, subsequent
;   calls to this function will fail.
;
; Credit and History:
;
;   Original author: Superfraggle
;   * Post: <http://www.autohotkey.com/board/topic/27670-add-tooltips-to-controls/>
;
;   Updated to support Unicode: art
;   * Post: <http://www.autohotkey.com/board/topic/27670-add-tooltips-to-controls/page-2#entry431059>
;
;   Additional: jballi.
;   Bug fixes.  Added support for x64.  Removed Modify parameter.  Added
;   additional functionality, constants, and documentation.
;
;-------------------------------------------------------------------------------
; #warn, off

AddTooltip(p1,p2:="",p3="")
{
    Static hTT := ""
     ;Global hTT := ""

          ;-- Misc. constants
          ,CW_USEDEFAULT:=0x80000000
          ,HWND_DESKTOP :=0

          ;-- Tooltip delay time constants
          ,TTDT_AUTOPOP:=2
                ;-- Set the amount of time a tooltip window remains visible if
                ;   the pointer is stationary within a tool's bounding
                ;   rectangle.

          ;-- Tooltip styles
          ,TTS_ALWAYSTIP:=0x1
                ;-- Indicates that the tooltip control appears when the cursor
                ;   is on a tool, even if the tooltip control's owner window is
                ;   inactive.  Without this style, the tooltip appears only when
                ;   the tool's owner window is active.

          ,TTS_NOPREFIX:=0x2
                ;-- Prevents the system from stripping ampersand characters from
                ;   a string or terminating a string at a tab character.
                ;   Without this style, the system automatically strips
                ;   ampersand characters and terminates a string at the first
                ;   tab character.  This allows an application to use the same
                ;   string as both a menu item and as text in a tooltip control.

          ;-- TOOLINFO uFlags
          ,TTF_IDISHWND:=0x1
                ;-- Indicates that the uId member is the window handle to the
                ;   tool.  If this flag is not set, uId is the identifier of the
                ;   tool.

          ,TTF_SUBCLASS:=0x10
                ;-- Indicates that the tooltip control should subclass the
                ;   window for the tool in order to intercept messages, such
                ;   as WM_MOUSEMOVE.  If this flag is not used, use the
                ;   TTM_RELAYEVENT message to forward messages to the tooltip
                ;   control.  For a list of messages that a tooltip control
                ;   processes, see TTM_RELAYEVENT.

          ;-- Tooltip icons
          ,TTI_NONE         :=0
          ,TTI_INFO         :=1
          ,TTI_WARNING      :=2
          ,TTI_ERROR        :=3
          ,TTI_INFO_LARGE   :=4
          ,TTI_WARNING_LARGE:=5
          ,TTI_ERROR_LARGE  :=6

          ;-- Extended styles
          ,WS_EX_TOPMOST:=0x8

          ;-- Messages
          ,TTM_ACTIVATE      :=0x401                    ;-- WM_USER + 1
          ,TTM_ADDTOOLA      :=0x404                    ;-- WM_USER + 4
          ,TTM_ADDTOOLW      :=0x432                    ;-- WM_USER + 50
          ,TTM_DELTOOLA      :=0x405                    ;-- WM_USER + 5
          ,TTM_DELTOOLW      :=0x433                    ;-- WM_USER + 51
          ,TTM_GETTOOLINFOA  :=0x408                    ;-- WM_USER + 8
          ,TTM_GETTOOLINFOW  :=0x435                    ;-- WM_USER + 53
          ,TTM_SETDELAYTIME  :=0x403                    ;-- WM_USER + 3
          ,TTM_SETMAXTIPWIDTH:=0x418                    ;-- WM_USER + 24
          ,TTM_SETTITLEA     :=0x420                    ;-- WM_USER + 32
          ,TTM_SETTITLEW     :=0x421                    ;-- WM_USER + 33
          ,TTM_UPDATETIPTEXTA:=0x40C                    ;-- WM_USER + 12
          ,TTM_UPDATETIPTEXTW:=0x439                    ;-- WM_USER + 57

    ;-- Save/Set DetectHiddenWindows
    l_DetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On

    ;-- Tooltip control exists?
    if not hTT
        {
        ;-- Create Tooltip window
        hTT:=DllCall("CreateWindowEx"
            ,"UInt",WS_EX_TOPMOST                       ;-- dwExStyle
            ,"Str","TOOLTIPS_CLASS32"                   ;-- lpClassName
            ,"Ptr",0                                    ;-- lpWindowName
            ,"UInt",TTS_ALWAYSTIP|TTS_NOPREFIX          ;-- dwStyle
            ,"UInt",CW_USEDEFAULT                       ;-- x
            ,"UInt",CW_USEDEFAULT                       ;-- y
            ,"UInt",CW_USEDEFAULT                       ;-- nWidth
            ,"UInt",CW_USEDEFAULT                       ;-- nHeight
            ,"Ptr",HWND_DESKTOP                         ;-- hWndParent
            ,"Ptr",0                                    ;-- hMenu
            ,"Ptr",0                                    ;-- hInstance
            ,"Ptr",0                                    ;-- lpParam
            ,"Ptr")                                     ;-- Return type

        ;-- Disable visual style
        ;   Note: Uncomment the following to disable the visual style, i.e.
        ;   remove the window theme, from the tooltip control.  Since this
        ;   function only uses one tooltip control, all tooltips created by this
        ;   function will be affected.
; DllCall("uxtheme\SetWindowTheme","Ptr",hTT,"Ptr",0,"UIntP",0)

        ;-- Set the maximum width for the tooltip window
        ;   Note: This message makes multi-line tooltips possible
        ; SendMessage TTM_SETMAXTIPWIDTH,0,A_ScreenWidth,,ahk_id %hTT% ;; og
		SendMessage TTM_SETMAXTIPWIDTH,0,A_ScreenWidth*96//A_ScreenDPI,,ahk_id %hTT%  ; <--- was A_ScreenWidth
        }

    ;-- Other commands
    if p1 is not Integer
        {
        if (p1="Activate")
            SendMessage TTM_ACTIVATE,True,0,,ahk_id %hTT%

        if (p1="Deactivate")
            SendMessage TTM_ACTIVATE,False,0,,ahk_id %hTT%

        if (InStr(p1,"AutoPop")=1)  ;-- Starts with "AutoPop"
            SendMessage TTM_SETDELAYTIME,TTDT_AUTOPOP,p2*1000,,ahk_id %hTT%
        
        if (p1="Title")
            {
            ;-- If needed, truncate the title
            if (StrLen(p2)>99)
                p2:=SubStr(p2,1,99)

            ;-- Icon
            if p3 is not Integer
                p3:=TTI_NONE

            ;-- Set title
            SendMessage A_IsUnicode ? TTM_SETTITLEW:TTM_SETTITLEA,p3,&p2,,ahk_id %hTT%
            }

        ;-- Restore DetectHiddenWindows
        DetectHiddenWindows %l_DetectHiddenWindows%
    
        ;-- Return the handle to the tooltip control
        Return hTT
        }

    ;-- Create/Populate the TOOLINFO structure
    uFlags:=TTF_IDISHWND|TTF_SUBCLASS
    cbSize:=VarSetCapacity(TOOLINFO,(A_PtrSize=8) ? 64:44,0)
    NumPut(cbSize,      TOOLINFO,0,"UInt")              ;-- cbSize
    NumPut(uFlags,      TOOLINFO,4,"UInt")              ;-- uFlags
    NumPut(HWND_DESKTOP,TOOLINFO,8,"Ptr")               ;-- hwnd
    NumPut(p1,          TOOLINFO,(A_PtrSize=8) ? 16:12,"Ptr")
        ;-- uId

    ;-- Check to see if tool has already been registered for the control
    SendMessage
        ,A_IsUnicode ? TTM_GETTOOLINFOW:TTM_GETTOOLINFOA
        ,0
        ,&TOOLINFO
        ,,ahk_id %hTT%

    l_RegisteredTool:=ErrorLevel

    ;-- Update the TOOLTIP structure
    NumPut(&p2,TOOLINFO,(A_PtrSize=8) ? 48:36,"Ptr")
        ;-- lpszText

    ;-- Add, Update, or Delete tool
    if l_RegisteredTool
        {
        if StrLen(p2)
            SendMessage
                ,A_IsUnicode ? TTM_UPDATETIPTEXTW:TTM_UPDATETIPTEXTA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%
         else
            SendMessage
                ,A_IsUnicode ? TTM_DELTOOLW:TTM_DELTOOLA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%
        }
    else
        if StrLen(p2)
            SendMessage
                ,A_IsUnicode ? TTM_ADDTOOLW:TTM_ADDTOOLA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%

    ;-- Restore DetectHiddenWindows
    DetectHiddenWindows %l_DetectHiddenWindows%

    ;-- Return the handle to the tooltip control
    Return hTT
    }
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------

