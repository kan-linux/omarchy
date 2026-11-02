echo "Skip: the AI coding agent feature has been removed"

# This migration used to swap the Gemini coding agent for Antigravity, which
# meant installing the `agy` CLI and moving the agent's skills over. Coding
# agents are no longer part of Omarchy, so there is nothing to migrate to.
# Left as a no-op rather than deleted so installs that already recorded this
# migration as done keep their history consistent.
