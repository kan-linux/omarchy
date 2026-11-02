echo "Remove the model usage widget"

# The widget this migration used to rename is gone, so there is nothing to
# rename it to. Strip both ids from a curated bar and from the disabled list,
# and drop the caches the widget and its scanner used to read. Idempotent.

config_file="$HOME/.config/omarchy/shell.json"

if [[ -s $config_file ]]; then
  tmp=$(mktemp)
  jq '
    def entry_id:
      if type == "string" then
        .
      elif type == "object" then
        (.id // "")
      else
        ""
      end;

    def drop_agent:
      map(select((entry_id) != "omarchy.agents" and (entry_id) != "omarchy.model-usage"));

    (if (.bar.layout? | type) == "object" then
      .bar.layout |= map_values(if type == "array" then drop_agent else . end)
    else . end)
    | (if (.disabledPlugins? | type) == "array" then
      .disabledPlugins |= map(select(. != "omarchy.agents" and . != "omarchy.model-usage"))
    else . end)
  ' "$config_file" >"$tmp" && mv "$tmp" "$config_file" || rm -f "$tmp"
fi

rm -rf "$HOME/.cache/omarchy/model-usage" "$HOME/.local/state/omarchy/agents"
