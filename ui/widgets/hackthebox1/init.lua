local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")
local apps = require("configuration.apps")
local clickable_container = require("ui.widgets.clickable-container")

local temp_text = wibox.widget {
  {
    id = 'hackthebox',
    widget = wibox.widget.imagebox,
    resize = true,
  },
--  layout = wibox.layout.align.horizontal,
  --font = "SF Pro Display Medium 12",
  font = "Material Icons ",
  widget = wibox.widget.textbox,
}

local temp_widget = wibox.widget.background()
temp_widget:set_widget(temp_text)

temp_widget:set_bg("#17161f")
temp_widget:set_fg("#008800")
temp_text:set_text("")
--temp_text:set_text("input1")

return temp_widget
