#!/bin/bash
ufw allow 2222/tcp
ufw --force enable
exec "$@"
