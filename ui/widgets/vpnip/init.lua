local beautiful = require("beautiful")
    local xresources = require("beautiful.xresources")
    local dpi = require("beautiful").xresources.apply_dpi
    local helpers = require("helpers")
    local apps = require("configuration.apps")
    local clickable_container = require("ui.widgets.clickable-container")
    local target = os.getenv("SET_TARGET") or " "
    local watch = require("awful.widget.watch")
    local wibox = require("wibox")
  
    local temp_text = wibox.widget {
    font = "SF Pro Display Medium 10",
    widget = wibox.widget.textbox,
    }

    local temp_widget = wibox.widget.background()
    temp_widget:set_widget(temp_text)

    temp_widget:set_bg("#17161f")
    temp_widget:set_fg("#D9D7D6")
    temp_text:set_text(tostring(target))

    watch("echo 10.10.16.36", 10, function(widget, stdout, stderr, exitreason, exitcode)
        -- Do something, for example
       temp_text:set_text(stdout)
     end,
      temp_widget
    )

    return temp_widget
