SendMode Input
#NoEnv
#SingleInstance force


options := {delay: 150, timeout: 300, doublePress: -1, swap_backtick_escape: false, mode: "ijkl"}
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
#If


#If true ; Override defaults.ahk. There will be "duplicate hotkey" errors otherwise.
*Space::
*Space UP::dual.combine("F22", A_ThisHotkey, {delay: options.delay, timeout: options.timeout, doublePress: options.doublePress})

*BackSpace::dual.comboKey({F22: "Delete"})

*\::dual.comboKey({F22: "Insert"})

*b::dual.comboKey({F22: "Space"})

*1::dual.comboKey({F22: "F1"})
*2::dual.comboKey({F22: "F2"})
*3::dual.comboKey({F22: "F3"})
*4::dual.comboKey({F22: "F4"})
*5::dual.comboKey({F22: "F5"})
*6::dual.comboKey({F22: "F6"})
*7::dual.comboKey({F22: "F7"})
*8::dual.comboKey({F22: "F8"})
*9::dual.comboKey({F22: "F9"})
*0::dual.comboKey({F22: "F10"})
*-::dual.comboKey({F22: "F11"})
*=::dual.comboKey({F22: "F12"})

*p::dual.comboKey({F22: "PrintScreen"})
*[::dual.comboKey({F22: "ScrollLock"})
*]::dual.comboKey({F22: "Pause"})

*e::dual.comboKey({F22: "Escape"})
*`::dual.comboKey("Escape", {F22: "``"})
#If


; NEEDS '*' because LCtrl key-repeat is otherwise interpreted as ALT+LCtrl.
; *LCtrl::
;     CtrlTabbed := false
;     Hotkey, *Tab, CtrlTab, On   ; Begin Ctrl+Tab (and release Alt) when we press Tab.

;     Send {Alt Down}             ; Press Alt (LCtrl::Alt)
;     KeyWait, LCtrl

;     if CtrlTabbed
;         Send {Ctrl Up}          ; Release Ctrl after Ctrl+Tabbing.
;     else
;         Send {Alt Up}{Lwin Up}           ; Release Alt (LCtrl::Alt)
   
;      Hotkey, *Tab, CtrlTab, Off


; return

; CtrlTab:
;     if (!CtrlTabbed) {
;         Send {Alt Up}           ; Release Alt now.
;         Send {Ctrl Down}        ; Press down Ctrl.
;         CtrlTabbed := true      ; Set a flag so we know to release Ctrl instead of Alt.
;     }
;     Send {Blind}{Tab}           ; Press Tab without releasing any modifiers.
; return




; If you want LCtrl and LAlt to both do Alt+Tab, replace all of the above with:
LCtrl::LWin


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

AltTab:
    if (!AltTabbed) {
        Send {Ctrl Up}          ; Release Ctrl now.
        Send {Alt Down}         ; Press down Alt. (Keeps the Alt+Tab menu open.)
        AltTabbed := true       ; Set a flag so we know to release Alt instead of Ctrl.
    }
    Send {Blind}{Tab}           ; Press Tab without releasing any modifiers.
return

Qclose:
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

*Ralt::RCTRL
*Rwin::Send {Lwin Down}{d}{Lwin Up}


$Capslock::
    Gui, 93:+Owner ; prevent display of taskbar button
    Gui, 93:Show, y-99999 NA, capslock-hole
    Send {RCtrl Down}
    KeyWait, Capslock ; wait until the Capslock button is released
    Gui, 93:Cancel
    Send, {RCtrl Up}
    ifinstring, A_PriorKey, Capslock
        ; Send, {Esc}
        SetCapsLockState % getkeystate("Capslock", "t") ? "off" : "on"
Return
