echo "Skip: the Tailscale integration has been removed"

# This migration used to enable omarchy-tailscale-receive.service so incoming
# Taildrop files landed in ~/Downloads. Tailscale and that service are no longer
# part of Omarchy, so there is nothing to enable.
# Left as a no-op rather than deleted so installs that already recorded this
# migration as done keep their history consistent.
