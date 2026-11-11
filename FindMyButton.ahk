#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook True
InstallKeybdHook
InstallMouseHook

; ============================================================================
; Press any mouse button. A window shows what Windows sees, and keeps a log.
; Catches: standard mouse buttons, wheel tilt/scroll, AND keyboard keys
; (many mice send keyboard keys for extra buttons).
; Esc quits.
; ============================================================================

g := Gui("+AlwaysOnTop", "Find My Button")
g.SetFont("s11")
g.SetFont("s14 bold")
g.Add("Text", "w460 cRed", "USE THE NAME IN THE [BRACKETS]`nand paste it into GestureButton in the gestures script.")
g.SetFont("s11 norm")
g.Add("Text", "w460", "Press buttons on your mouse. Esc quits.`nIf nothing appears, you probably remapped that button in your mouse's own software. Reset it there, or map it to something unused (Back/Forward).")
logBox := g.Add("Edit", "w460 r14 ReadOnly")
g.Show()

; "~" lets the click still work normally; no "*" blocking.
for b in ["LButton", "RButton", "MButton", "XButton1", "XButton2"
        , "WheelUp", "WheelDown", "WheelLeft", "WheelRight"]
    Hotkey("~*" b, Report.Bind("MOUSE", b))

; Any keyboard key a mouse might emit
ih := InputHook("V L0")
ih.KeyOpt("{All}", "N")
ih.OnKeyDown := (ih, vk, sc) => Report("KEY", GetKeyName(Format("vk{:x}sc{:x}", vk, sc)), Format("vk{:02X} sc{:03X}", vk, sc))
ih.Start()

Report(kind, name, extra := "", *) {
    global logBox
    line := FormatTime(, "HH:mm:ss") "  " kind ":  [" name "]" (extra != "" ? "   " extra : "")
    logBox.Value := line "`r`n" logBox.Value
}

Hotkey("~Esc", (*) => ExitApp())
