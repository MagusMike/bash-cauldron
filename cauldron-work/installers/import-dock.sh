#!/bin/bash

# variable and function declarations

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# get the currently logged in user
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

# global check if there is a user logged in
if [ -z "$currentUser" -o "$currentUser" = "loginwindow" ]; then
  echo "no user logged in, cannot proceed"
  exit 1
fi
# now we know a user is logged in

# get the current user's UID
uid=$(id -u "$currentUser")

# convenience function to run a command as the current user
# usage:
#   runAsUser command arguments...
runAsUser() {  
  if [ "$currentUser" != "loginwindow" ]; then
    launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
    echo "no user logged in"
    # uncomment the exit command
    # to make the function exit with an error when no user is logged in
    # exit 1
  fi
}

#### Check for apps and then open them

if [[ -e /Applications/zoom.us.app ]] && [[ -e /Applications/Openvpn\ Connect ]]; then
  echo "opening app and setting dock shortcut"
  runAsUser open "/Applications/Google Chrome.app"
  runAsUser open /Applications/zoom.us.app
  runAsUser open /Applications/Slack.app
  runAsUser open "/Applications/OpenVPN Connect/OpenVPN Connect.app"
  runAsUser open "Applications/Self Service.app"
else
  echo "applications not found in /Applications/"
  exit 1
fi

#####
# Create local file for plist replacement with xml import

echo "creating file"

(
    cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>DesktopAdminImageGenerationNumber</key>
	<dict>
		<key>GenerationNumber</key>
		<string>2</string>
	</dict>
	<key>loc</key>
	<string>en_US:US</string>
	<key>mod-count</key>
	<integer>8</integer>
	<key>persistent-apps</key>
	<array>
		<dict>
			<key>GUID</key>
			<integer>181083795</integer>
			<key>tile-data</key>
			<dict>
				<key>book</key>
				<data>
				Ym9va2QCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAAhAEAAAQAAAADAwAAAAAAIAwA
				AAABAQAAQXBwbGljYXRpb25zDwAAAAEBAABPcGVuVlBO
				IENvbm5lY3QAEwAAAAEBAABPcGVuVlBOIENvbm5lY3Qu
				YXBwAAwAAAABBgAAEAAAACQAAAA8AAAACAAAAAQDAABu
				5jUAAAAAAAgAAAAEAwAASSQBAAAAAAAIAAAABAMAAEok
				AQAAAAAADAAAAAEGAABsAAAAfAAAAIwAAAAIAAAAAAQA
				AEHDD8gKljI3GAAAAAECAAACAAAAAAAAAA8AAAAAAAAA
				AAAAAAAAAAAIAAAAAQkAAGZpbGU6Ly8vDAAAAAEBAABN
				YWNpbnRvc2ggSEQIAAAABAMAAABQBl46AAAACAAAAAAE
				AABBwd5EgAAAACQAAAABAQAARjQ2NkYxQUUtNjA3Ny00
				QjdCLUE1ODUtRjE5OUQ3NkIyNzREGAAAAAECAACBAAAA
				AQAAAO8TAAABAAAAAAAAAAAAAAABAAAAAQEAAC8AAAAA
				AAAAAQUAAKgAAAD+////AQAAAAAAAAANAAAABBAAAFgA
				AAAAAAAABRAAAJwAAAAAAAAAEBAAAMAAAAAAAAAAQBAA
				ALAAAAAAAAAAAiAAAHABAAAAAAAABSAAAOAAAAAAAAAA
				ECAAAPAAAAAAAAAAESAAACQBAAAAAAAAEiAAAAQBAAAA
				AAAAEyAAABQBAAAAAAAAICAAAFABAAAAAAAAMCAAAHwB
				AAAAAAAAENAAAAQAAAAAAAAA
				</data>
				<key>bundle-identifier</key>
				<string>org.openvpn.client.app</string>
				<key>dock-extra</key>
				<false/>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///Applications/OpenVPN%20Connect/OpenVPN%20Connect.app/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>OpenVPN Connect</string>
				<key>file-mod-date</key>
				<integer>48936263158037</integer>
				<key>file-type</key>
				<integer>1</integer>
				<key>parent-mod-date</key>
				<integer>6261468104982</integer>
			</dict>
			<key>tile-type</key>
			<string>file-tile</string>
		</dict>
		<dict>
			<key>GUID</key>
			<integer>181083796</integer>
			<key>tile-data</key>
			<dict>
				<key>book</key>
				<data>
				Ym9vaywCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAATAEAAAQAAAADAwAAAAAAIAwA
				AAABAQAAQXBwbGljYXRpb25zCQAAAAEBAABTbGFjay5h
				cHAAAAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAABu5jUA
				AAAAAAgAAAAEAwAAdEpHAAAAAAAIAAAAAQYAAEgAAABY
				AAAACAAAAAAEAABBwzPziwAAABgAAAABAgAAAgAAAAAA
				AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
				LwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQDAAAAUAZe
				OgAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEAAEY0NjZG
				MUFFLTYwNzctNEI3Qi1BNTg1LUYxOTlENzZCMjc0RBgA
				AAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAA
				AAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAAAAAA
				DQAAAAQQAAA4AAAAAAAAAAUQAABoAAAAAAAAABAQAACI
				AAAAAAAAAEAQAAB4AAAAAAAAAAIgAAA4AQAAAAAAAAUg
				AACoAAAAAAAAABAgAAC4AAAAAAAAABEgAADsAAAAAAAA
				ABIgAADMAAAAAAAAABMgAADcAAAAAAAAACAgAAAYAQAA
				AAAAADAgAABEAQAAAAAAABDQAAAEAAAAAAAAAA==
				</data>
				<key>bundle-identifier</key>
				<string>com.tinyspeck.slackmacgap</string>
				<key>dock-extra</key>
				<false/>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///Applications/Slack.app/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>Slack</string>
				<key>file-mod-date</key>
				<integer>3705495574</integer>
				<key>file-type</key>
				<integer>1</integer>
				<key>parent-mod-date</key>
				<integer>174100208978773</integer>
			</dict>
			<key>tile-type</key>
			<string>file-tile</string>
		</dict>
		<dict>
			<key>GUID</key>
			<integer>1164722461</integer>
			<key>tile-data</key>
			<dict>
				<key>book</key>
				<data>
				Ym9vazQCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAAVAEAAAQAAAADAwAAAAAAIAwA
				AAABAQAAQXBwbGljYXRpb25zEQAAAAEBAABHb29nbGUg
				Q2hyb21lLmFwcAAAAAgAAAABBgAAEAAAACQAAAAIAAAA
				BAMAAG7mNQAAAAAACAAAAAQDAABdEgEAAAAAAAgAAAAB
				BgAAUAAAAGAAAAAIAAAAAAQAAEHDCUD5gAAAGAAAAAEC
				AAACAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAAAQkA
				AGZpbGU6Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQIAAAA
				BAMAAABQBl46AAAACAAAAAAEAABBwd5EgAAAACQAAAAB
				AQAARjQ2NkYxQUUtNjA3Ny00QjdCLUE1ODUtRjE5OUQ3
				NkIyNzREGAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAA
				AAAAAAABAAAAAQEAAC8AAAAAAAAAAQUAAKgAAAD+////
				AQAAAAAAAAANAAAABBAAAEAAAAAAAAAABRAAAHAAAAAA
				AAAAEBAAAJAAAAAAAAAAQBAAAIAAAAAAAAAAAiAAAEAB
				AAAAAAAABSAAALAAAAAAAAAAECAAAMAAAAAAAAAAESAA
				APQAAAAAAAAAEiAAANQAAAAAAAAAEyAAAOQAAAAAAAAA
				ICAAACABAAAAAAAAMCAAAEwBAAAAAAAAENAAAAQAAAAA
				AAAA
				</data>
				<key>bundle-identifier</key>
				<string>com.google.Chrome</string>
				<key>dock-extra</key>
				<false/>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///Applications/Google%20Chrome.app/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>Google Chrome</string>
				<key>file-mod-date</key>
				<integer>3709427888</integer>
				<key>file-type</key>
				<integer>1</integer>
				<key>parent-mod-date</key>
				<integer>174100208978773</integer>
			</dict>
			<key>tile-type</key>
			<string>file-tile</string>
		</dict>
		<dict>
			<key>GUID</key>
			<integer>1164722462</integer>
			<key>tile-data</key>
			<dict>
				<key>book</key>
				<data>
				Ym9vaywCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAATAEAAAQAAAADAwAAAAAAIAwA
				AAABAQAAQXBwbGljYXRpb25zCwAAAAEBAAB6b29tLnVz
				LmFwcAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAABu5jUA
				AAAAAAgAAAAEAwAA7o9KAAAAAAAIAAAAAQYAAEgAAABY
				AAAACAAAAAAEAABBw1N9+J8EiBgAAAABAgAAAgAAAAAA
				AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
				LwwAAAABAQAATWFjaW50b3NoIEhECAAAAAQDAAAAUAZe
				OgAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEAAEY0NjZG
				MUFFLTYwNzctNEI3Qi1BNTg1LUYxOTlENzZCMjc0RBgA
				AAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAA
				AAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAAAAAA
				DQAAAAQQAAA4AAAAAAAAAAUQAABoAAAAAAAAABAQAACI
				AAAAAAAAAEAQAAB4AAAAAAAAAAIgAAA4AQAAAAAAAAUg
				AACoAAAAAAAAABAgAAC4AAAAAAAAABEgAADsAAAAAAAA
				ABIgAADMAAAAAAAAABMgAADcAAAAAAAAACAgAAAYAQAA
				AAAAADAgAABEAQAAAAAAABDQAAAEAAAAAAAAAA==
				</data>
				<key>bundle-identifier</key>
				<string>us.zoom.xos</string>
				<key>dock-extra</key>
				<false/>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///Applications/zoom.us.app/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>zoom.us</string>
				<key>file-mod-date</key>
				<integer>249184827241743</integer>
				<key>file-type</key>
				<integer>1</integer>
				<key>parent-mod-date</key>
				<integer>174100208978773</integer>
			</dict>
			<key>tile-type</key>
			<string>file-tile</string>
		</dict>
		<dict>
			<key>GUID</key>
			<integer>1164722463</integer>
			<key>tile-data</key>
			<dict>
				<key>book</key>
				<data>
				Ym9va1ACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAAcAEAAAQAAAADAwAAAAAAIAYA
				AAABAQAAU3lzdGVtAAAMAAAAAQEAAEFwcGxpY2F0aW9u
				cxYAAAABAQAAU3lzdGVtIFByZWZlcmVuY2VzLmFwcAAA
				DAAAAAEGAAAQAAAAIAAAADQAAAAIAAAABAMAABUAAAD/
				//8PCAAAAAQDAAAXAAAA////DwgAAAAEAwAA6SYBAP//
				/w8MAAAAAQYAAGgAAAB4AAAAiAAAAAgAAAAABAAAQcHe
				RIAAAAAYAAAAAQIAAAIAAAAAAAAADwAAAAAAAAAAAAAA
				AAAAAAgAAAABCQAAZmlsZTovLy8MAAAAAQEAAE1hY2lu
				dG9zaCBIRAgAAAAEAwAAAFAGXjoAAAAkAAAAAQEAAEY0
				NjZGMUFFLTYwNzctNEI3Qi1BNTg1LUYxOTlENzZCMjc0
				RBgAAAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAA
				AQAAAAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAA
				AAAADQAAAAQQAABUAAAAAAAAAAUQAACYAAAAAAAAABAQ
				AAC8AAAAAAAAAEAQAACsAAAAAAAAAAIgAABcAQAAAAAA
				AAUgAADcAAAAAAAAABAgAADsAAAAAAAAABEgAAAQAQAA
				AAAAABIgAAAAAQAAAAAAABMgAACsAAAAAAAAACAgAAA8
				AQAAAAAAADAgAABoAQAAAAAAABDQAAAEAAAAAAAAAA==
				</data>
				<key>bundle-identifier</key>
				<string>com.apple.systempreferences</string>
				<key>dock-extra</key>
				<true/>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///System/Applications/System%20Preferences.app/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>System Preferences</string>
				<key>file-mod-date</key>
				<integer>3660710400</integer>
				<key>file-type</key>
				<integer>1</integer>
				<key>parent-mod-date</key>
				<integer>3660710400</integer>
			</dict>
			<key>tile-type</key>
			<string>file-tile</string>
		</dict>
		<dict>
			<key>GUID</key>
			<integer>181083797</integer>
			<key>tile-data</key>
			<dict>
				<key>book</key>
				<data>
				Ym9vazACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAAUAEAAAQAAAADAwAAAAAAIAwA
				AAABAQAAQXBwbGljYXRpb25zEAAAAAEBAABTZWxmIFNl
				cnZpY2UuYXBwCAAAAAEGAAAQAAAAJAAAAAgAAAAEAwAA
				buY1AAAAAAAIAAAABAMAAEqrPAAAAAAACAAAAAEGAABM
				AAAAXAAAAAgAAAAABAAAQcNDJ6yAAAAYAAAAAQIAAAIA
				AAAAAAAADwAAAAAAAAAAAAAAAAAAAAgAAAABCQAAZmls
				ZTovLy8MAAAAAQEAAE1hY2ludG9zaCBIRAgAAAAEAwAA
				AFAGXjoAAAAIAAAAAAQAAEHB3kSAAAAAJAAAAAEBAABG
				NDY2RjFBRS02MDc3LTRCN0ItQTU4NS1GMTk5RDc2QjI3
				NEQYAAAAAQIAAIEAAAABAAAA7xMAAAEAAAAAAAAAAAAA
				AAEAAAABAQAALwAAAAAAAAABBQAAqAAAAP7///8BAAAA
				AAAAAA0AAAAEEAAAPAAAAAAAAAAFEAAAbAAAAAAAAAAQ
				EAAAjAAAAAAAAABAEAAAfAAAAAAAAAACIAAAPAEAAAAA
				AAAFIAAArAAAAAAAAAAQIAAAvAAAAAAAAAARIAAA8AAA
				AAAAAAASIAAA0AAAAAAAAAATIAAA4AAAAAAAAAAgIAAA
				HAEAAAAAAAAwIAAASAEAAAAAAAAQ0AAABAAAAAAAAAA=
				</data>
				<key>bundle-identifier</key>
				<string>com.jamfsoftware.selfservice.mac</string>
				<key>dock-extra</key>
				<false/>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///Applications/Self%20Service.app/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>Self Service</string>
				<key>file-mod-date</key>
				<integer>62100345587197</integer>
				<key>file-type</key>
				<integer>1</integer>
				<key>parent-mod-date</key>
				<integer>174100208978773</integer>
			</dict>
			<key>tile-type</key>
			<string>file-tile</string>
		</dict>
	</array>
	<key>persistent-others</key>
	<array>
		<dict>
			<key>GUID</key>
			<integer>747564940</integer>
			<key>tile-data</key>
			<dict>
				<key>arrangement</key>
				<integer>2</integer>
				<key>book</key>
				<data>
				Ym9va4QCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAAgAEAAAQAAAADAwAAAAAAIAUA
				AAABAQAAVXNlcnMAAAAMAAAAAQEAAG1pa2V3aWxsaWFt
				cwkAAAABAQAARG93bmxvYWRzAAAADAAAAAEGAAAQAAAA
				IAAAADQAAAAIAAAABAMAADJhAAAAAAAACAAAAAQDAABF
				kgAAAAAAAAgAAAAEAwAAeJIAAAAAAAAMAAAAAQYAAFwA
				AABsAAAAfAAAAAgAAAAABAAAQcHeRIAAAAAYAAAAAQIA
				AAIAAAAAAAAADwAAAAAAAAAAAAAAAAAAAAgAAAAEAwAA
				AQAAAAAAAAAEAAAAAwMAAPcBAAAIAAAAAQkAAGZpbGU6
				Ly8vDAAAAAEBAABNYWNpbnRvc2ggSEQIAAAABAMAAABQ
				Bl46AAAAJAAAAAEBAABGNDY2RjFBRS02MDc3LTRCN0It
				QTU4NS1GMTk5RDc2QjI3NEQYAAAAAQIAAIEAAAABAAAA
				7xMAAAEAAAAAAAAAAAAAAAEAAAABAQAALwAAAAAAAAAB
				BQAAzAAAAP7///8BAAAAAAAAABAAAAAEEAAASAAAAAAA
				AAAFEAAAjAAAAAAAAAAQEAAAsAAAAAAAAABAEAAAoAAA
				AAAAAAACIAAAbAEAAAAAAAAFIAAA7AAAAAAAAAAQIAAA
				/AAAAAAAAAARIAAAIAEAAAAAAAASIAAAEAEAAAAAAAAT
				IAAAoAAAAAAAAAAgIAAATAEAAAAAAAAwIAAAeAEAAAAA
				AAABwAAA0AAAAAAAAAARwAAAIAAAAAAAAAASwAAA4AAA
				AAAAAAAQ0AAABAAAAAAAAAA=
				</data>
				<key>displayas</key>
				<integer>0</integer>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///Users/mikewilliams/Downloads/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>Downloads</string>
				<key>file-mod-date</key>
				<integer>252101110216560</integer>
				<key>file-type</key>
				<integer>2</integer>
				<key>parent-mod-date</key>
				<integer>33517339642054</integer>
				<key>preferreditemsize</key>
				<integer>-1</integer>
				<key>showas</key>
				<integer>1</integer>
			</dict>
			<key>tile-type</key>
			<string>directory-tile</string>
		</dict>
	</array>
	<key>recent-apps</key>
	<array>
		<dict>
			<key>GUID</key>
			<integer>1164722466</integer>
			<key>tile-data</key>
			<dict>
				<key>book</key>
				<data>
				Ym9va3ACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
				AAAAAAAAAAAAAAAAAAAAkAEAAAQAAAADAwAAAAAAIAYA
				AAABAQAAU3lzdGVtAAAMAAAAAQEAAEFwcGxpY2F0aW9u
				cwkAAAABAQAAVXRpbGl0aWVzAAAADAAAAAEBAABUZXJt
				aW5hbC5hcHAQAAAAAQYAABAAAAAgAAAANAAAAEgAAAAI
				AAAABAMAABUAAAD///8PCAAAAAQDAAAXAAAA////DwgA
				AAAEAwAAbjwBAP///w8IAAAABAMAAHuoAQD///8PEAAA
				AAEGAAB0AAAAhAAAAJQAAACkAAAACAAAAAAEAABBwd5E
				gAAAABgAAAABAgAAAgAAAAAAAAAPAAAAAAAAAAAAAAAA
				AAAACAAAAAEJAABmaWxlOi8vLwwAAAABAQAATWFjaW50
				b3NoIEhECAAAAAQDAAAAUAZeOgAAACQAAAABAQAARjQ2
				NkYxQUUtNjA3Ny00QjdCLUE1ODUtRjE5OUQ3NkIyNzRE
				GAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAAAAAAAAAB
				AAAAAQEAAC8AAAAAAAAAAQUAAKgAAAD+////AQAAAAAA
				AAANAAAABBAAAFwAAAAAAAAABRAAALQAAAAAAAAAEBAA
				ANwAAAAAAAAAQBAAAMwAAAAAAAAAAiAAAHwBAAAAAAAA
				BSAAAPwAAAAAAAAAECAAAAwBAAAAAAAAESAAADABAAAA
				AAAAEiAAACABAAAAAAAAEyAAAMwAAAAAAAAAICAAAFwB
				AAAAAAAAMCAAAIgBAAAAAAAAENAAAAQAAAAAAAAA
				</data>
				<key>bundle-identifier</key>
				<string>com.apple.Terminal</string>
				<key>dock-extra</key>
				<false/>
				<key>file-data</key>
				<dict>
					<key>_CFURLString</key>
					<string>file:///System/Applications/Utilities/Terminal.app/</string>
					<key>_CFURLStringType</key>
					<integer>15</integer>
				</dict>
				<key>file-label</key>
				<string>Terminal</string>
				<key>file-mod-date</key>
				<integer>3660710400</integer>
				<key>file-type</key>
				<integer>1</integer>
				<key>parent-mod-date</key>
				<integer>3660710400</integer>
			</dict>
			<key>tile-type</key>
			<string>file-tile</string>
		</dict>
	</array>
	<key>region</key>
	<string>US</string>
	<key>trash-full</key>
	<true/>
	<key>version</key>
	<integer>1</integer>
</dict>
</plist>
EOF
) > /private/tmp/import.xml

#######
# sleep and then run the import and check

sleep 3

if [[ -f /private/tmp/import.xml ]]; then
  echo "running import for dock settings"
  runAsUser defaults import com.apple.dock /private/tmp/import.xml
  sleep 3
  killall Dock
else
  echo "this did not work properly"
  exit 1
fi 

exit 0