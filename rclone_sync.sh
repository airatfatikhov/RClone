#!/bin/bash

SOURCE_DIR="/var/atlassian/application-data/jira/data/attachments/"
REMOTE="jira_backup:/mnt/backup/jira/attachments/"
CONFIG="/etc/rclone/rclone.conf"

rclone sync "$SOURCE_DIR" "$REMOTE" \
    --config "$CONFIG" \
    --transfers 16 \
    --checkers 8 \
    --delete \
    --stats 1m