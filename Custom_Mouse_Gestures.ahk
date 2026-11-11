#Requires AutoHotkey v2.0
#SingleInstance Force

; ############################################################################
; DEFAULT CONTROLS (HOLD THE GESTURE BUTTON, THEN SWIPE)
;   SWIPE LEFT  = PREVIOUS SONG
;   SWIPE RIGHT = NEXT SONG
;   SWIPE DOWN  = PLAY / PAUSE
;   SWIPE UP    = SCROLL WHEEL SWITCHES TO VOLUME (SWIPE UP AGAIN TO SWITCH BACK)
;   TAP         = MUTE / UNMUTE
;   RESET       = CTRL+ALT+V (BACK TO NORMAL SCROLLING)
; CHANGE ANY OF THESE IN THE CONFIG BELOW. SEE THE README FOR MORE.
; ############################################################################


; ############################################################################
; CONFIG
; ############################################################################

; BUTTON THAT TRIGGERS THE GESTURES
GestureButton := "MButton"

; PIXELS OF MOVEMENT BEFORE IT COUNTS AS A SWIPE
MoveThreshold := 18

; ACTIONS: ANY AUTOHOTKEY SEND TEXT (EG "{Media_Next}" OR "^c")
; "" DOES NOTHING
; "WHEEL_TOGGLE" SWITCHES THE SCROLL WHEEL BETWEEN NORMAL AND VOLUME
TapAction        := "{Volume_Mute}"
SwipeLeftAction  := "{Media_Prev}"
SwipeRightAction := "{Media_Next}"
SwipeUpAction    := "WHEEL_TOGGLE"
SwipeDownAction  := "{Media_Play_Pause}"

; SCROLL WHEEL ACTIONS WHILE IN VOLUME MODE
WheelUpAction   := "{Volume_Up}"
WheelDownAction := "{Volume_Down}"

; EMERGENCY RESET HOTKEY (^ = CTRL, ! = ALT, + = SHIFT, # = WIN)
ResetHotkey := "^!v"

; ############################################################################
; END OF CONFIG
; ############################################################################


; ############################################################################
; STATE
; ############################################################################

global gStartX := 0
global gStartY := 0
global gHandled := false      ; TRUE ONCE THIS PRESS HAS BEEN HANDLED (SWIPE OR TAP)
global gHeld := false         ; TRUE WHILE THE BUTTON IS DOWN
global gWheelVolume := false  ; TRUE WHEN THE WHEEL IS IN VOLUME MODE
global gLastDown := 0         ; TIME OF THE LAST BUTTON DOWN, USED TO SPOT STALE STATE


; ############################################################################
; EMERGENCY RESET
; ############################################################################

Hotkey(ResetHotkey, (*) => ResetWheel())
A_TrayMenu.Add("Reset scroll wheel to normal", (*) => ResetWheel())

ResetWheel() {
    global gWheelVolume, gHeld
    gWheelVolume := false
    gHeld := false
    SetTimer(TrackMovement, 0)
    ToolTip("Scroll wheel: NORMAL SCROLL (reset)")
    SetTimer(() => ToolTip(), -1200)
}


; ############################################################################
; BUTTON BINDING
; ############################################################################

Hotkey("*" GestureButton, GestureDown)
Hotkey("*" GestureButton " Up", GestureUp)


; ############################################################################
; RUN AN ACTION
; ############################################################################

DoAction(action) {
    if (action = "")
        return
    if (action = "WHEEL_TOGGLE")
        ToggleWheel()
    else
        Send(action)
}


; ############################################################################
; BUTTON PRESSED
; ############################################################################

GestureDown(*) {
    global gStartX, gStartY, gHandled, gHeld, gLastDown
    ; IGNORE KEY AUTO-REPEAT WHILE HELD
    ; IF NOTHING ARRIVED FOR 1.2S THE HELD STATE IS STALE, SO START FRESH
    if (gHeld && A_TickCount - gLastDown < 1200) {
        gLastDown := A_TickCount
        return
    }
    gLastDown := A_TickCount
    gHeld := true
    MouseGetPos(&gStartX, &gStartY)
    gHandled := false
    SetTimer(TrackMovement, 10)
}


; ############################################################################
; SWIPES
; ############################################################################

TrackMovement() {
    global gStartX, gStartY, gHandled, MoveThreshold
    global SwipeLeftAction, SwipeRightAction, SwipeUpAction, SwipeDownAction
    if (gHandled)
        return
    MouseGetPos(&x, &y)
    dx := x - gStartX    ; POSITIVE = MOVED RIGHT
    dy := y - gStartY    ; POSITIVE = MOVED DOWN
    if (Abs(dx) > MoveThreshold || Abs(dy) > MoveThreshold) {
        gHandled := true
        SetTimer(TrackMovement, 0)
        if (Abs(dx) > Abs(dy))
            DoAction(dx > 0 ? SwipeRightAction : SwipeLeftAction)
        else
            DoAction(dy < 0 ? SwipeUpAction : SwipeDownAction)
    }
}


; ############################################################################
; BUTTON RELEASED (NO SWIPE MEANS IT WAS A TAP)
; ############################################################################

GestureUp(*) {
    global gHeld, gHandled, TapAction
    gHeld := false
    SetTimer(TrackMovement, 0)
    if (!gHandled) {
        gHandled := true
        DoAction(TapAction)
    }
}


; ############################################################################
; VOLUME MODE
; ############################################################################

ToggleWheel() {
    global gWheelVolume
    gWheelVolume := !gWheelVolume
    ToolTip(gWheelVolume ? "Scroll wheel: VOLUME" : "Scroll wheel: NORMAL SCROLL")
    SetTimer(() => ToolTip(), -1200)
}

; WHEEL ONLY CHANGES WHILE VOLUME MODE IS ON
#HotIf gWheelVolume
WheelUp::DoAction(WheelUpAction)
WheelDown::DoAction(WheelDownAction)
#HotIf


; ############################################################################
; TRAY
; ############################################################################

; HOVER TEXT
A_IconTip := "Custom Mouse Gestures`nGesture button: " GestureButton "`nRight-click for reset"

; GREYED OUT HEADER AT THE TOP OF THE TRAY MENU
A_TrayMenu.Insert("1&", "Gesture button: " GestureButton "  (active)", (*) => 0)
A_TrayMenu.Disable("1&")
A_TrayMenu.Insert("2&")
A_TrayMenu.Rename("Reset scroll wheel to normal", "Reset (click if stuck)")

; STARTUP POPUP
TrayTip("Bound to: " GestureButton "`nStuck? Right-click tray icon to Reset",
    "Custom Mouse Gestures", "Iconi Mute")
