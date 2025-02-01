#!/bin/bash
# original source: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

bar_color="#a6da95"
volume_step=5
brightness_step=0.1  # Ajusta el valor de brillo (0.1 es un 10%)
max_volume=100

# Uses regex to get volume from pactl
function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

# Uses regex to get mute status from pactl
function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

# Uses xrandr to get brightness
function get_brightness {
    brightness=$(xrandr --verbose | grep -A5 "eDP" | grep "Brightness" | awk '{print $2}')
    echo $brightness
}

# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon="󰸈  "
    elif [ "$volume" -lt 50 ]; then
        volume_icon="󰕾  "
    else
        volume_icon="  "
    fi
}

# Always returns the same icon for brightness
function get_brightness_icon {
    brightness_icon="  "
}

# Displays a volume notification using dunstify
function show_volume_notif {
    volume=$(get_mute)
    get_volume_icon
    dunstify -t 300 -r 2593 -u normal "$volume_icon $volume%" -h int:value:$volume -h string:hlcolor:$bar_color
}

# Displays a brightness notification using dunstify
function show_brightness_notif {
    brightness=$(get_brightness)
    brightness_percentage=$(echo "$brightness * 100" | bc)
    get_brightness_icon
    dunstify -t 300 -r 2593 -u normal "$brightness_icon $brightness_percentage%" -h int:value:$brightness_percentage -h string:hlcolor:$bar_color
}

# Main function - Takes user input, "volume_up", "volume_down", "brightness_up", or "brightness_down"
case $1 in
    volume_up)
    # Unmutes and increases volume, then displays the notification
    pactl set-sink-mute @DEFAULT_SINK@ 0
    volume=$(get_volume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
    else
        pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
    fi
    show_volume_notif
    ;;

    volume_down)
    # Decreases volume and displays the notification
    pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
    show_volume_notif
    ;;

    volume_mute)
    # Toggles mute and displays the notification
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    show_volume_notif
    ;;

    brightness_up)
    # Increases brightness and displays the notification
    brightness=$(get_brightness)
    new_brightness=$(echo "$brightness + $brightness_step" | bc)
    if (( $(echo "$new_brightness <= 1" | bc -l) )); then
        xrandr --output eDP --brightness $new_brightness
    fi
    show_brightness_notif
    ;;

    brightness_down)
    # Decreases brightness and displays the notification
    brightness=$(get_brightness)
    new_brightness=$(echo "$brightness - $brightness_step" | bc)
    if (( $(echo "$new_brightness >= 0" | bc -l) )); then
        xrandr --output eDP --brightness $new_brightness
    fi
    show_brightness_notif
    ;;
esac
