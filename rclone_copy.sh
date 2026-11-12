#!/bin/bash

SOURCE_DIR="/var/atlassian/application-data/jira/data/attachments/"
REMOTE="jira_backup:/mnt/backup/jira/attachments/"
CONFIG="/etc/rclone/rclone.conf"

rclone copy "$SOURCE_DIR" "$REMOTE" \
    --config "$CONFIG" \
    --transfers 32 \
    --checkers 128 \
    --fast-list \
    --size-only \
    --max-backlog 200000 \
    --buffer-size 64M \
    --stats 1m \
    --log-file=/var/log/rclone-copy.log \
    --log-level INFO