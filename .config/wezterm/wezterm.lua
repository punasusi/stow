local wezterm = require 'wezterm'
local act = wezterm.action

local config = {
  font = wezterm.font('Hack Nerd Font Mono'), -- Replace with your preferred font name
  font_size = 12.0, -- Adjust font size
  enable_tab_bar = false,
  window_decorations = "RESIZE",
  window_background_opacity = 0.75,
  macos_window_background_blur = 10,
  color_scheme = 'Tokyo Night',
  keys = {
    -- Remove the default SUPER+K key binding
    { key = 'k', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment },

    -- Set SUPER+K to clear scrollback and viewport
    { key = 'k', mods = 'CMD', action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },
  },
}

return config
