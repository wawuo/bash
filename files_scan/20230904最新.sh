#!/bin/bash
myfile="/list/"
iceterTime="`date '+%Y%m%d%H%M%S'`"
echo "$iceterTime" >>/tmp/运行记录
path=/var/www/html/data/admin/files/

#判断inotifywait 进程是否存在，如果不存在就启动它
PIDS=`ps -ef |grep inotifywait |grep -v grep | awk '{print $2}'`
if [ "$PIDS" != "" ]; then
    echo "inotifywait is runing!"
    #inotifywaitf运行时可以运行以下do -done
    sudo inotifywait -m -r -e move "$path" | while read -r directory event file
    do
        if [[ "$file" != *.part ]]; then
            echo "移动文件: $directory$file"  >> /tmp/更新记录.1
            touch --no-create  "$directory$file"
            sudo -u www-data php /var/www/html/occ app:disable files_automatedtagging
            sudo -u www-data php /var/www/html/occ files:scan admin --path="$directory$file"
            sudo -u www-data php /var/www/html/occ app:enable  files_automatedtagging
        fi
    done
else 
    #inotifywaitf没有运行时先运行inotifywaitf再运行以下do -done
    cd /root/
    #运行进程
    #sudo inotifywait -r -m -e 'moved_to' -o /ilist /var/www/html/data/admin/files/
    sudo inotifywait -m -r -e move "$path" | while read -r directory event file
    do
        if [[ "$file" != *.part ]]; then
            echo "移动文件: $directory$file"  >> /tmp/更新记录.1
            touch --no-create  "$directory$file"
            sudo -u www-data php /var/www/html/occ app:disable files_automatedtagging
            sudo -u www-data php /var/www/html/occ files:scan admin --path="$directory$file" 
  	    sudo -u www-data php /var/www/html/occ app:enable  files_automatedtagging
        fi
    done
fi

