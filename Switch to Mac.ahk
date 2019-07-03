SendMode Input
#NoEnv
#SingleInstance force
    

options := {delay: 10, timeout: 200, doublePress: -1, swap_backtick_escape: false, mode: "hjkl"}
loop %0% {
    arg := %A_Index%
    argSplit := StrSplit(arg, "=")
    option := argSplit[1]
    value := argSplit[2]
    options[option] := value
}

#Include <dual/dual>
dual := new Dual

#Include <dual/defaults>

#If options.mode == "hjkl"
    *h::dual.comboKey({F22: "Left"})
*j::dual.comboKey({F22: "Down"})
*k::dual.comboKey({F22: "Up"})
*l::dual.comboKey({F22: "Right"})
*d::dual.comboKey({F22: "PgDn"})
*u::dual.comboKey({F22: "PgUp"})

*1::dual.comboKey({F22: "!"})
*2::dual.comboKey({F22: "@"})
*3::dual.comboKey({F22: "#"})
*4::dual.comboKey({F22: "$"})
*5::dual.comboKey({F22: "%"})
*6::dual.comboKey({F22: "^"})
*7::dual.comboKey({F22: "&"})
*8::dual.comboKey({F22: "*"})
*9::dual.comboKey({F22: "("})
*0::dual.comboKey({F22: ")"})
*-::dual.comboKey({F22: "_"})
*=::dual.comboKey({F22: "+"})
*[::dual.comboKey({F22: "{"}) 
*]::dual.comboKey({F22: "}"}) 
*\::dual.comboKey({F22: "|"}) 
*;::dual.comboKey({F22: ":"}) 
*'::dual.comboKey({F22: """"}) 
*,::dual.comboKey({F22: "<"}) 
*.::dual.comboKey({F22: ">"}) 
*/::dual.comboKey({F22: "?"}) 

#If
    

#If true ; Override defaults.ahk. There will be "duplicate hotkey" errors otherwise.
    *Space::
    *Space UP::dual.combine("F22", A_ThisHotkey, {delay: options.delay, timeout: options.timeout, doublePress: options.doublePress})
    
    ; *BackSpace::dual.comboKey({F22: "Delete"})
    
    ; *\::dual.comboKey({F22: "Insert"})
    
    ; *b::dual.comboKey({F22: "Space"})
    
    ; *p::dual.comboKey({F22: "PrintScreen"})
    ; *[::dual.comboKey({F22: "ScrollLock"})
    ; *]::dual.comboKey({F22: "Pause"})
    
    ; *e::dual.comboKey({F22: "Escape"})
    ; *`::dual.comboKey("Escape", {F22: "``"})
    #If
        
    
    ; If you want LCtrl and LAlt to both do Alt+Tab, replace all of the above with
    LCtrl::RAlt
    
    
    ; NEEDS '*' because LAlt key-repeat is otherwise interpreted as CTRL+LAlt.
*LAlt::
    AltTabbed := false
    Hotkey, *Tab, AltTab, On    ; Begin Alt+Tab (and release Ctrl) when we press Tab.
    Hotkey, *q, Qclose, On
    ;!!!! alt+d to desktop
    ; Hotkey, *d, DshowDesktop, On
    Send {Ctrl Down}            ; Press Ctrl (LAlt::Ctrl)
    KeyWait, LAlt
    if AltTabbed
        Send {Alt Up}          ; Release Alt after Alt+Tabbing.
    else
        Send {Ctrl Up}	          ; Release Ctrl (LAlt::Ctrl)
    Hotkey, *Tab, AltTab, Off
    Hotkey, *q, Qclose, Off
    ;!!!! alt + d to desktop
    ; Hotkey, *d, DshowDesktop, Off
return

AltTab: ; LAlt + W to cmd + w
    if (!AltTabbed) {
        Send {Ctrl Up}          ; Release Ctrl now.
        Send {Alt Down}         ; Press down Alt. (Keeps the Alt+Tab menu open.)
        AltTabbed := true       ; Set a flag so we know to release Alt instead of Ctrl.
    }
    Send {Blind}{Tab}           ; Press Tab without releasing any modifiers.
return

Qclose: ; LAlt + Q to Alt+F4
    if (!AltTabbed) {
        Send {Ctrl Up}          ; Release Ctrl now.
        Send {Alt Down}         ; Press down Alt. (Keeps the Alt+Tab menu open.)
        AltTabbed := true       ; Set a flag so we know to release Alt instead of Ctrl.
    }
    Send {Blind}{F4}           ; Press Tab without releasing any modifiers.
return

; !!!! alt + d to desktop
; DshowDesktop:
; if (!AltTabbed) {
;     Send {Ctrl Up}          ; Release Ctrl now.
;     Send {Lwin Down}         ; Press down Alt. (Keeps the Alt+Tab menu open.)
;     AltTabbed := true       ; Set a flag so we know to release Alt instead of Ctrl.
; }
; Send {Blind}{d}{Lwin up}           ; Press Tab without releasing any modifiers.
; return

; CAPSLOCK::LCTRL
; +CAPSLOCK::CAPSLOCK

; *Ralt::RCTRL
*AppsKey::Send #{d}

$Capslock:: ;tab to switch language, press for ctrl
    Gui, 93:+Owner ; prevent display of taskbar button
    Gui, 93:Show, y-99999 NA, capslock-hole
    Send {RCtrl Down}
    KeyWait, Capslock ; wait until the Capslock button is released
    Gui, 93:Cancel
    Send, {RCtrl Up}
    ifinstring, A_PriorKey, Capslock
        Send, #{Space}
    ; SetCapsLockState % getkeystate("Capslock", "t") ? "off" : "on"
Return

;Ralt + JK to navigate btw tabs
RAlt & j:: Send ^+{Tab}
RAlt & k:: Send ^{Tab}

Home:: WinMaximize, A

+Home:: 
    {
        Send +#{Left}
        WinMaximize, A
        Return
    }
    
    End:: WinMinimize, A
; PgUp:: Send #{Left}
; PgDn:: Send #{Right}

!l:: ;Alt + l to show/hide vscode
    {
        DetectHiddenWindows, on
        SetTitleMatchMode 2 
        ifWinNotExist Visual Studio Code
            Run C:\Users\xxx\AppData\Local\Programs\Microsoft VS Code\Code.exe
        else
        {
            ifWinNotActive Visual Studio Code
                WinActivate Visual Studio Code
            else
                WinMinimize
        }
        Return
    }
    
!k:: ;Alt + k to show/hide chrome
    {
        DetectHiddenWindows, on
        SetTitleMatchMode 2 
        ifWinNotExist Chrome
            Run C:\Users\xxx\AppData\Local\Google\Chrome\Application\chrome.exe
        else
        {
            ifWinNotActive Chrome
                WinActivate Chrome
            else
                WinMinimize
        }
        Return
    }
    
!o:: ; Alt + o to show/hide explorer
    {
        DetectHiddenWindows, on
        SetTitleMatchMode 2 
        ifWinNotExist ahk_class CabinetWClass
            Run C:\Windows\explorer.exe
        else
        {
            ifWinNotActive ahk_class CabinetWClass
                WinActivate ahk_class CabinetWClass
            else
                WinMinimize
        }
        Return
    }
    
!n:: ; Alt + n to show/hide notepad
    {
        DetectHiddenWindows, on
        SetTitleMatchMode 2 
        ifWinNotExist ahk_class Notepad++
            Run C:\Program Files\Notepad++\notepad++.exe
        else
        {
            ifWinNotActive ahk_class Notepad++
                WinActivate
            else
                WinMinimize
        }
        Return
    }
    
    
!y:: ; Alt+y to show/hide typora
    {
        DetectHiddenWindows, on
        SetTitleMatchMode 2 
        ifWinNotExist Typora
            Run C:\TyporaPortable\App\Typora\Typora.exe
        else
        {
            ifWinNotActive Typora
                WinActivate Typora
            else
                WinMinimize
        }
        Return
    }
    
!m:: ; Alt+M to show/hide outlook
    {
        DetectHiddenWindows, on
        SetTitleMatchMode 2 
        ifWinNotExist Outlook
            Run C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook 2016 
        else
        {
            ifWinNotActive Outlook
                WinActivate Outlook
            else
                WinMinimize
        }
        Return
    }
    
$RShift:: ; tab to Shift + Tab(Show/Hide Conemu), press to Shift
    Send {RShift Down}
        KeyWait, RShift ; wait until the RShift button is released
        Send, {RShift Up}
        ifinstring, A_PriorKey, RShift
        Send, +{Space}
Return
