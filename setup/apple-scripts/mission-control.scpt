tell application "System Settings"
	activate
  get properties
  reveal pane id "com.apple.Keyboard-Settings.extension"
  delay 1.0
end tell


tell application "System Events"
  tell window 1 of application process "System Settings"
    tell button 3 of group 2 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1
      click
    end tell
    delay 0.5
    keystroke "M"
    keystroke "I"
    keystroke "S"
    get entire contents
  end tell
end tell
