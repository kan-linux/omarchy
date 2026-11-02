echo "Remove the agents widget from the bar"

# The widget this migration used to add is gone. Strip it from every section of
# a curated bar, along with the id it had before the rename, so an existing
# install ends up matching the shipped default instead of carrying a bar entry
# nothing can resolve. Idempotent: removing an absent id is a no-op.

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

rm -rf "$HOME/.local/state/omarchy/agents"
