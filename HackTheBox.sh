#!/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

# Variables Globales
vpn_path=~/.config/awesome/ui/widgets/vpnip/init.lua
target_path=~/.config/awesome/ui/widgets/targetip/init.lua
ip_regex=$(echo $1 | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)")

function helpPanel(){
  echo -e "\n${redColour}[!]${endColour}${grayColour} Usage:${endColour}${greenColour} HackTheBox ${endColour}<Target IP> <OPTIONS>\n"
  echo -e "\n${blueColour}[*]${endColour}${grayColour} OPTIONS: ${endColour}"
  echo -e "\n\t${yellowColour}h) ${endColour}${grayColour}Show this pannel${endColour}"
  echo -e "\n\t${yellowColour}r) ${endColour}${grayColour}Set both IP on \"None\"${endColour}"
}
function setvpnip(){

  # Conozco si estoy ejecutando una vpn
  vpn=$(systemctl status | grep openvpn | grep -v grep | head -1 | sed "s/^ .*openvpn/openvpn/g" | awk '{print $1}')

  # Si la estoy ejecutando parseo la ip y la introduzco en la bar
  if [[ $vpn == "openvpn" ]]; then
    vpnip=$(ifconfig | grep tun0 -1 | tail -1 | awk '{print $2}')
    echo "local beautiful = require(\"beautiful\")
    local xresources = require(\"beautiful.xresources\")
    local dpi = require(\"beautiful\").xresources.apply_dpi
    local helpers = require(\"helpers\")
    local apps = require(\"configuration.apps\")
    local clickable_container = require(\"ui.widgets.clickable-container\")
    local target = os.getenv(\"SET_TARGET\") or \" \"
    local watch = require(\"awful.widget.watch\")
    local wibox = require(\"wibox\")
  
    local temp_text = wibox.widget {
    font = \"SF Pro Display Medium 10\",
    widget = wibox.widget.textbox,
    }

    local temp_widget = wibox.widget.background()
    temp_widget:set_widget(temp_text)

    temp_widget:set_bg(\"#17161f\")
    temp_widget:set_fg(\"#D9D7D6\")
    temp_text:set_text(tostring(target))

    watch(\"echo $vpnip\", 10, function(widget, stdout, stderr, exitreason, exitcode)
        -- Do something, for example
       temp_text:set_text(stdout)
     end,
      temp_widget
    )

    return temp_widget" > $vpn_path
  else
    setNone $vpn_path

  fi
}
function setNone(){
    echo "local beautiful = require(\"beautiful\")
    local xresources = require(\"beautiful.xresources\")
    local dpi = require(\"beautiful\").xresources.apply_dpi
    local helpers = require(\"helpers\")
    local apps = require(\"configuration.apps\")
    local clickable_container = require(\"ui.widgets.clickable-container\")
    local target = os.getenv(\"SET_TARGET\") or \" \"
    local watch = require(\"awful.widget.watch\")
    local wibox = require(\"wibox\")

    local temp_text = wibox.widget {
      font = \"SF Pro Display Medium 10\",
      widget = wibox.widget.textbox,
    }

    local temp_widget = wibox.widget.background()
    temp_widget:set_widget(temp_text)

    temp_widget:set_bg(\"#17161f\")
    temp_widget:set_fg(\"#D9D7D6\")
    temp_text:set_text(tostring(target))

    watch(\"echo None\", 10, function(widget, stdout, stderr, exitreason, exitcode)
       temp_text:set_text(stdout)
     end,
      temp_widget
    )

    return temp_widget" > "${1}"
}
function set_target_ip(){
  echo "local beautiful = require(\"beautiful\")
  local xresources = require(\"beautiful.xresources\")
  local dpi = require(\"beautiful\").xresources.apply_dpi
  local helpers = require(\"helpers\")
  local apps = require(\"configuration.apps\")
  local clickable_container = require(\"ui.widgets.clickable-container\")
  local target = os.getenv(\"SET_TARGET\") or \" \"
  local watch = require(\"awful.widget.watch\")
  local wibox = require(\"wibox\")
  
  local temp_text = wibox.widget {
  font = \"SF Pro Display Medium 10\",
  widget = wibox.widget.textbox,
  }

  local temp_widget = wibox.widget.background()
  temp_widget:set_widget(temp_text)

  temp_widget:set_bg(\"#17161f\")
  temp_widget:set_fg(\"#D9D7D6\")
  temp_text:set_text(tostring(target))
  
  watch(\"echo $1\", 10, function(widget, stdout, stderr, exitreason, exitcode)
      temp_text:set_text(tostring(stdout))
    end,
    temp_widget
  )

  return temp_widget" > $target_path
}

# Set bar
function set_bar(){
  xdotool key shift+ctrl+alt+9 &>/dev/null
  exit 0
}


# Main

if [[ $(id -u) == 0 ]]; then
  echo -e "\n${redColour}[!]${endColour}${grayColour} You mustnt run this script as root${endColour}\n"
  exit 1
elif [[ $# != 1 ]]; then
  helpPanel
  exit 1
elif [[ $1 == "-r" ]] || [[ $1 == "--reset" ]];then
  setNone $vpn_path
  setNone $target_path
  set_bar
elif [[ $1 == "-h" ]] || [[ $1 == "--help" ]];then
  helpPanel
  exit 0
elif [[ $1 == "$ip_regex" ]]; then
  setvpnip
  set_target_ip "$1" 
  set_bar
else
  helpPanel
  exit 1
fi


