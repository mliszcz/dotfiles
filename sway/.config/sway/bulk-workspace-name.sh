#!/usr/bin/env bash

read -r -d '' JQ_PROGRAM_ALL <<'EOF'
.nodes[].nodes[]
  | select(.num != null)
  | { num, apps: [.. | .app_id? // .window_properties?.class? | values] | unique }
  | { num, apps: .apps | join(" ") | ascii_downcase }
  | @text "\"rename workspace number \(.num) to '\(.num): \(.apps)'\""
EOF

read -r -d '' JQ_PROGRAM_FIRST <<'EOF'
.nodes[].nodes[]
  | select(.num != null)
  | { num, apps: [.. | .app_id? // .window_properties?.class? | values] | .[0] | ascii_downcase }
  | @text "\"rename workspace number \(.num) to '\(.num): \(.apps)'\""
EOF

(while true; do stdbuf -o0 swaymsg -t get_tree; sleep 1; done) \
  | jq --unbuffered --raw-output "$JQ_PROGRAM_FIRST" \
  | ~/.config/sway/application-to-icon.sh \
  | tee /dev/stderr \
  | xargs -n 1 -- swaymsg
