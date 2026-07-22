#!/bin/bash
set -e

# Hestia Control Panel installer wrapper
# Docs: https://hestiacp.com/docs/introduction/getting-started
#
# IMPORTANT: Hestia must run on a FRESH OS install.
# Do NOT run this after full-setup.sh or after installing nginx/mysql/etc.
# Hestia installs its own web stack, databases, mail and firewall.
#
# Usage:
#   sudo bash panel/hestiacp.sh
#   sudo bash panel/hestiacp.sh --interactive no --hostname panel.example.com --email admin@example.com --password 'secret'
#
# Pass any official installer flags through this script (see: bash hst-install.sh -h)

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: run this script as root (sudo)."
  exit 1
fi

if [ -d /usr/local/hestia ]; then
  echo "HestiaCP already appears to be installed (/usr/local/hestia)."
  echo "Panel URL: https://$(hostname -f):8083"
  exit 0
fi

echo "==> Preparing dependencies..."
apt-get update
apt-get install -y wget curl ca-certificates lsb-release

INSTALL_DIR="$(mktemp -d /tmp/hestiacp-install.XXXXXX)"
trap 'rm -rf "$INSTALL_DIR"' EXIT
cd "$INSTALL_DIR"

echo "==> Downloading official Hestia installer..."
INSTALLER_URL="https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh"

if ! wget --timeout=30 --tries=3 -O hst-install.sh "$INSTALLER_URL"; then
  echo "wget failed, trying curl..."
  if ! curl --fail --location --connect-timeout 30 --retry 3 -o hst-install.sh "$INSTALLER_URL"; then
    echo "Error: could not download Hestia installer from GitHub."
    echo "Check outbound HTTPS (443) and try again:"
    echo "  curl -I $INSTALLER_URL"
    exit 1
  fi
fi

if [ ! -s hst-install.sh ]; then
  echo "Error: downloaded installer is empty."
  exit 1
fi

chmod +x hst-install.sh
echo "    Download OK ($(wc -c < hst-install.sh) bytes)."

# Contabo (and some cloud images) ship an "admin" group that blocks Hestia.
# Official installer accepts --force for this case.
FORCE_ARGS=()
has_force=false
for arg in "$@"; do
  case "$arg" in
    -f|--force) has_force=true ;;
  esac
done

if getent group admin >/dev/null 2>&1 && [ "$has_force" = false ]; then
  echo "==> Group 'admin' already exists (common on Contabo images)."
  echo "    Passing --force so the official installer can continue."
  FORCE_ARGS=(--force)
fi

echo "==> Starting HestiaCP installation..."
echo "    (interactive prompts unless you passed --interactive no and required flags)"
bash hst-install.sh "${FORCE_ARGS[@]}" "$@"

echo
echo "==> HestiaCP install finished."
echo "    Access the panel at: https://YOUR_SERVER_IP:8083"
echo "    or: https://YOUR_HOSTNAME:8083"
echo "    Default backend port: 8083"
echo
echo "    Useful commands after install:"
echo "      v-list-sys-info"
echo "      v-change-user-password admin 'newpassword'"
echo "      systemctl status hestia"
