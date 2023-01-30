local select = require "select"
local follow = require "follow"
local settings = require "settings"

-- Alternating left/right-hand letters in labels.
select.label_maker = function ()
    local chars = interleave("qwertasdfgzxcvb", "yuiophjklnm")
    return trim(sort(reverse(chars)))
end

-- Use only labels for navigation. Do not consider element text.
follow.pattern_maker = follow.pattern_styles.match_label

follow.stylesheet = follow.stylesheet .. [[
#luakit_select_overlay .hint_label {
    font-size: 20px;
}
]]

-- Enable HW acceleration. This also is a workaround for a broken mouse scrol.
-- https://github.com/luakit/luakit/issues/1007
settings.webview.hardware_acceleration_policy = "always"

settings.webview.enable_smooth_scrolling = true

settings.webview.enable_accelerated_2d_canvas = true
