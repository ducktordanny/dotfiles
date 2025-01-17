tell application "System Settings"
	activate
  reveal pane id "com.apple.Lock-Screen-Settings.extension"
  delay 1.0
end tell

tell application "System Events"
  tell window 1 of application process "System Settings"
    tell pop up button "Start Screen Saver when inactive" of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1
      click
      delay 0.25
      keystroke "F"
      keystroke "O"
      keystroke "R"
      keystroke " "
      keystroke "2"
      keystroke " "
      keystroke "H"
      keystroke "O"
      keystroke "U"
      keystroke "R"
      keystroke "S"
      keystroke return
    end tell
    delay 0.5

    tell pop up button "Turn display off on battery when inactive" of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1
      click
      delay 0.25
      keystroke "N"
      keystroke "E"
      keystroke "V"
      keystroke "E"
      keystroke "R"
      keystroke return
    end tell
    delay 0.5

    tell pop up button "Turn display off on power adapter when inactive" of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1
      click
      delay 0.25
      keystroke "N"
      keystroke "E"
      keystroke "V"
      keystroke "E"
      keystroke "R"
      keystroke return
    end tell
    delay 0.5

    tell pop up button "Require password after screen saver begins or display is turned off" of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1
      click
      delay 0.25
      keystroke "A"
      keystroke "F"
      keystroke "T"
      keystroke "E"
      keystroke "R"
      keystroke " "
      keystroke "5"
      keystroke " "
      keystroke "M"
      keystroke return
    end tell
  end tell
end tell
