#!/bin/bash
set -e
apt install -y postgresql postgresql-contrib
systemctl enable postgresql && systemctl start postgresql
