#!/usr/bin/env bash
set -euo pipefail

cd /app

bash deploy.sh
bash /opt/borg-backups/run_all.sh
