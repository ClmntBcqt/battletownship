#!/bin/bash

set -e

if [[ -z "${BATTLETOWNSHIP_BACKEND_DIR:-}" ]]; then
    echo "Erreur : BATTLETOWNSHIP_BACKEND_DIR n'est pas définie."
    exit 1
fi

source "$BATTLETOWNSHIP_BACKEND_DIR/.env"

"$BATTLETOWNSHIP_BACKEND_DIR/bin/applyMigrations" --connection "$ConnectionStrings__DefaultConnection"

sudo tee /etc/systemd/system/battletownship_backend.service > /dev/null <<EOF
[Unit]
Description=BattleTownship ASP.NET Core backend
After=network.target

[Service]
Type=exec
WorkingDirectory=$BATTLETOWNSHIP_BACKEND_DIR/publish
ExecStart=$BATTLETOWNSHIP_BACKEND_DIR/publish/backend
EnvironmentFile=$BATTLETOWNSHIP_BACKEND_DIR/.env
Restart=always
RestartSec=10
User=battletownship
SyslogIdentifier=battletownship_backend

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable battletownship_backend
sudo systemctl restart battletownship_backend 