echo "Skip: the AI coding agent feature has been removed"

# This migration used to retire a mise-built Hermes and point the user at
# re-choosing their default agent. Coding agents and the default-agent setting
# are no longer part of Omarchy, so there is nothing to migrate.
# Left as a no-op rather than deleted so installs that already recorded this
# migration as done keep their history consistent.
