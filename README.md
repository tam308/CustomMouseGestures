# Mouse Gestures

AutoHotkey v2 scripts that turn one button on any mouse into media gestures.

## Files

- `FindMyButton.ahk`: press your mouse buttons to see the name to use (shown in `[brackets]`).
- `Custom_Mouse_Gestures.ahk`: the gesture script. Config is at the top.

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/) (v1 will not work).
2. Run `FindMyButton.ahk` and press the button you want to use.
3. Put the name shown in `[brackets]` into `GestureButton` in `Custom_Mouse_Gestures.ahk`.
4. Run `Custom_Mouse_Gestures.ahk`.

If the finder shows nothing for a button, you probably remapped it in your mouse's own software. Either reset it there, or map it to something unused (Back or Forward work well).

## Controls

| Gesture | Action |
|---|---|
| Tap | Mute / unmute |
| Swipe left | Previous song |
| Swipe right | Next song |
| Swipe down | Play / pause |
| Swipe up | Scroll wheel switches to / from volume mode |

If something gets stuck, press **Ctrl+Alt+V** or right-click the tray icon and choose Reset.

## Changing the controls

Open `Custom_Mouse_Gestures.ahk` in any text editor. Save it and re-run it to apply changes.

Everything is set in the CONFIG section near the top of the file:

- **Gesture button:** `GestureButton`.
- **Tap and swipes:** `TapAction`, `SwipeLeftAction`, `SwipeRightAction`, `SwipeUpAction`, `SwipeDownAction`. Set each to any `Send` text, `""` to do nothing, or `"WHEEL_TOGGLE"` to switch the scroll wheel between normal and volume mode.
- **Volume-mode wheel:** `WheelUpAction` and `WheelDownAction`.
- **Sensitivity:** `MoveThreshold`. Lower means shorter swipes.
- **Reset hotkey:** `ResetHotkey`, in AutoHotkey syntax (`^` Ctrl, `!` Alt, `+` Shift, `#` Win).

Handy key names for `Send`:

| Action | Text |
|---|---|
| Next / previous track | `{Media_Next}` / `{Media_Prev}` |
| Play / pause | `{Media_Play_Pause}` |
| Volume up / down / mute | `{Volume_Up}` / `{Volume_Down}` / `{Volume_Mute}` |
| Copy / paste | `^c` / `^v` |
| Browser back / forward | `{Browser_Back}` / `{Browser_Forward}` |

Any key or combo works. See the [AutoHotkey Send docs](https://www.autohotkey.com/docs/v2/lib/Send.htm) for the full list.

## Run on startup

To have the script start every time Windows does:

1. Press **Win+R**, type `shell:startup` and press Enter. This opens your Startup folder (`%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`).
2. Right-click `Custom_Mouse_Gestures.ahk`, choose **Show more options > Create shortcut**, and move the shortcut into the Startup folder.
3. Sign out and back in (or double-click the shortcut) to check it starts.

Use a shortcut instead of copying the file, so edits you make to the script in this folder still apply. If you do copy the file there, edit that copy instead. To stop it running on startup, delete the shortcut.

## Notes

- While the script runs, the gesture button no longer does its normal job (for example, MButton stops middle-clicking). If the button sends a keyboard key, that key is blocked too.
- Swipes need the button to be held while you move. If your mouse sends the button as an instant tap, swipes will not work. Map it to Back or Forward in your mouse's own software instead.
- To quit, right-click the tray icon and choose Exit.
- Windows running as administrator (for example Task Manager) ignores the script unless the script is also run as administrator.
