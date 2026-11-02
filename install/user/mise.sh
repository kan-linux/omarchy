# Upgrades must not delete the version a running process is executing from:
# mise up would prune the old install dir out from under a live session.
mise settings set upgrade.auto_prune false

omarchy-mise-install gh
omarchy-mise-install npm:playwright playwright
omarchy-mise-install npm:@kitlangton/ghui ghui
omarchy-mise-install aqua:modem-dev/hunk hunk
omarchy-mise-install github:basecamp/hey-cli hey
omarchy-mise-install github:basecamp/basecamp-cli basecamp
omarchy-mise-install npm:cf cf
