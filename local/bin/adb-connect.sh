gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "ADB connection helper"
PORT=$(gum input --placeholder "Enter device IP address & Port")
PIN=$(gum input --placeholder "Enter device pin")

gum spin --title "Using port $(gum style --italic --foreground "#04B575" $PORT) with pin $(gum style --italic --foreground 99 $PIN)" adb pair $PORT $PIN
echo "Pairing $(gum style --bold "successful")."

sleep 1; clear

gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Connection mode"
PORT=$(gum input --placeholder "Enter device IP address & Port to connect")
gum spin --title "Using port $(gum style --italic --foreground "#04B575" $PORT) to connect" adb connect $PORT

gum style --border normal --margin "1" --padding "1 2" --border-foreground "#04B575" "Done!"
