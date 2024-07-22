#!/bin/bash

# 监控的目录
WATCH_DIR="/var/www/html/data/admin/files"

# 日志路径
LOG_FILE="/var/log/nextcloud/file_changes.log"

# 备份旧日志文件
mv $LOG_FILE /tmp
touch $LOG_FILE

# 启动监控进程
nohup inotifywait -r -m -e create,modify,delete $WATCH_DIR |
    while read path action file; do
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ${path}/${file} - ${action}" | tee -a $LOG_FILE
    done &
