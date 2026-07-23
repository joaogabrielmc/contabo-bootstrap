#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

apt-get update
apt-get install -y gnupg curl ca-certificates

install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /etc/apt/keyrings/mongodb-server-7.0.gpg
chmod 0644 /etc/apt/keyrings/mongodb-server-7.0.gpg

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
printf '%s\n' "# MongoDB repository for Ubuntu ${CODENAME}" "deb [signed-by=/etc/apt/keyrings/mongodb-server-7.0.gpg] https://repo.mongodb.org/apt/ubuntu ${CODENAME}/mongodb-org/7.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-7.0.list

apt-get update
apt-get install -y mongodb-org

systemctl enable mongod
systemctl start mongod
systemctl status mongod --no-pager
