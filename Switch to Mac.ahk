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


; ========== space + hjkldu to vim-like movements, space + numbers to !@#$%^&*()_+
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


; ========== use LAlt + Tab like Cmd + Tab
; NEEDS '*' because LAlt key-repeat is otherwise interpreted as CTRL+LAlt.
*LAlt::
    AltTabbed := false
    Hotkey, *Tab, AltTab, On    ; Begin Alt+Tab (and release Ctrl) when we press Tab.
    Hotkey, *q, Qclose, On
    ; Hotkey, *d, DshowDesktop, On
    Send {Ctrl Down}            ; Press Ctrl (LAlt::Ctrl)
    KeyWait, LAlt
    if AltTabbed
        Send {Alt Up}          ; Release Alt after Alt+Tabbing.
    else
        Send {Ctrl Up}	          ; Release Ctrl (LAlt::Ctrl)
    Hotkey, *Tab, AltTab, Off
    Hotkey, *q, Qclose, Off
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


; ========== Use LAlt + Q like Cmd + Q
Qclose: 
    if (!AltTabbed) {
        Send {Ctrl Up}          ; Release Ctrl now.
        Send {Alt Down}         ; Press down Alt. (Keeps the Alt+Tab menu open.)
        AltTabbed := true       ; Set a flag so we know to release Alt instead of Ctrl.
    }
    Send {Blind}{F4}           ; Press Tab without releasing any modifiers.
return


; ========== Change RAlt to Ctrl
*RAlt::
    Send {Ctrl Down}
    KeyWait, RAlt
    Send {Ctrl Up}
return


; ========== LCtrl to RAlt
LCtrl::RAlt


; ========== Use RAlt + jk to switch tabs in window
Ralt & k::Send ^{Tab}
Ralt & j::Send ^+{Tab}
;Ralt + JK to navigate btw tabs


; ========== Use LAlt + w like Cmd + w
Cycle: 
    if (!RAltTabbed) {
        RAltTabbed := true       ; Set a flag so we know to release Alt instead of Ctrl.
    }
    Send {Blind}+{Tab}           ; Press Tab without releasing any modifiers.
return

CycleForward: 
    Send {Ctrl Down}
    if (!RAltTabbed) {
        RAltTabbed := true       ; Set a flag so we know to release Alt instead of Ctrl.
    }
    Send {Blind}{Tab}           ; Press Tab without releasing any modifiers.
return


; ========== Right who-knows-what key to show desktop
*AppsKey::Send #{d}


; ========== tab to switch language, press for ctrl 
$Capslock::
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


; ========== Home key to Maximize current window, End to Minimize, Shift+Home to Maximize onto other screen.
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


; ========== Alt + l to show/hide vscode
!l::
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


; ========== Alt + k to show/hide chrome    
!k:: 
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


; ========== Alt + o to show/hide explorer
!o:: 
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


; ========== Alt + n to show/hide notepad    
!n:: 
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


; ========== Alt+y to show/hide typora
!y::
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


; ========== Alt+M to show/hide outlook
!m:: 
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


; ========== tab to Shift + Tab(Show/Hide Conemu), press to Shift
$RShift:: 
    Send {RShift Down}
        KeyWait, RShift ; wait until the RShift button is released
        Send, {RShift Up}
        ifinstring, A_PriorKey, RShift
        Send, +{Space}
Return


; ========== something old
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
