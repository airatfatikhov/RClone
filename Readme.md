🔄 Простая синхронизация вложений через Rclone

📦 Установка Rclone (сервер A — источник)

```
curl https://rclone.org/install.sh | sudo bash
```

🔧 Конфиг Rclone

Создайте файл /etc/rclone/rclone.conf:
```
sudo mkdir -p /etc/rclone
sudo nano /etc/rclone/rclone.conf
```

Содержимое:
```
[jira_backup]
type = sftp
host = REMOTE_IP
user = backupuser
key_file = /home/jira/.ssh/id_ed25519
ask_password = false
```

Права:
```
sudo chown jira:jira /etc/rclone/rclone.conf
sudo chmod 600 /etc/rclone/rclone.conf
```

✅ Проверка подключения

```
sudo -u jira rclone --config /etc/rclone/rclone.conf ls jira_backup:/mnt/backup/jira/attachments/
```
Если видите файлы (или пустоту) — всё работает.

📜 Скрипт синхронизации

Создайте /opt/scripts/sync_jira_attachments.sh:
```
sudo nano /opt/scripts/sync_jira_attachments.sh
```

Содержимое:
```
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
```

Права:
```
sudo chmod +x /opt/scripts/sync_jira_attachments.sh
sudo chown jira:jira /opt/scripts/sync_jira_attachments.sh
```

⏰ Cron

```
sudo crontab -u jira -e

*/15 * * * * /opt/scripts/sync_jira_attachments.sh >> /var/log/jira_sync.log 2>&1
```

🧪 Тестовый запуск

```
sudo -u jira /opt/scripts/sync_jira_attachments.sh
```