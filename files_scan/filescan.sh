

#!/bin/bash

# 监测文件夹的路径
WATCH_FOLDER="/var/www/html/data/admin/files/"

# 用于记录事件的日志
EVENT_LOG="/var/log/nextcloud/实时更新.log"

# 尝试停止监测进程
pkill -f "inotifywait -m -e moved_to  -r ${WATCH_FOLDER}"

# 启动监测进程
inotifywait -m -r  -e moved_to --format '%w%f' "${WATCH_FOLDER}" | while read file; do
  # 更新文件时间戳
  touch "$file"
  
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $file updated." >> "${EVENT_LOG}"
  
  # 去除不需要的文件路径部分
  new_path="${file//\/var\/www\/html\/data\//}"
  
  # 执行 NextCloud 文件扫描命令
  sleep 0.03
  sudo -u www-data php /var/www/html/occ app:disable files_automatedtagging
  sudo -u www-data php /var/www/html/occ files:scan --path "$new_path" >> "${EVENT_LOG}" 2>&1
  sudo -u www-data php /var/www/html/occ app:enable files_automatedtagging
done &
