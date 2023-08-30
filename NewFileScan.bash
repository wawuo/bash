#!/bin/bash

# 定义变量
list_path="/list/"
ilist_path="/ilist"
log_path="/home/user/运行记录"
update_record_path="/home/user/更新记录.1"
data_path="/var/www/html/data"
filescan_app="files_automatedtagging"

# 定义日志函数
log() {
    logger -t "脚本名称" "$1"
}

# 检查文件是否存在
file_exists() {
    if [[ ! -e "$1" ]]; then
        return 1
    fi
    return 0
}

# 复制文件并设置权限
copy_file_with_permission() {
    cp "$1" "$2"
    chmod 777 "$1" "$2"
}

# 清空文件内容
clear_file() {
    echo -n > "$1"
}

# 删除文件中的指定字符串
remove_string_from_file() {
    sed -i "s/$1//g" "$2"
}

# 更新文件的修改时间
update_file_modification_time() {
    touch "$1"
}

# 追加文件路径到更新记录文件
append_to_update_record() {
    echo "$1" >> "$update_record_path"
}

# 删除文件的第一行
delete_first_line() {
    sed -i '1d' "$1"
}

# 替换文件中的字符串
replace_string_in_file() {
    sed -i "s|$1|$2|g" "$3"
}

# 扫描文件并打印sum值
scan_file_and_print_sum() {
    sum=1
    /var/www/html/occ files:scan --path="$1"
    echo "sum: $sum"
    ((sum++))
}

# 启用或禁用应用
enable_disable_app() {
    /var/www/html/occ app:disable "$1"
    /var/www/html/occ app:enable "$1"
}

# 监听文件移动事件并记录到ilist文件
monitor_file_movements() {
    inotifywait -m "$1" -e moved_to -e moved_from |
    while read -r path action file; do
        log "文件 $file 移动到 $path"
        echo "MOVED_TO $file" >> "$ilist_path"
    done
}

# 主要逻辑
{
    # 记录运行时间
    iceterTime=$(date +%Y%m%d%H%M%S)
    echo "$iceterTime" >> "$log_path"

    # 检查并复制ilist文件到list目录
    if file_exists "$list_path"; then
        copy_file_with_permission "$ilist_path" "$list_path"
    fi

    # 追加ilist内容到list文件，并清空ilist
    cat "$ilist_path" >> "$list_path"
    clear_file "$ilist_path"

    # 删除list文件中的MOVED_TO字符串
    remove_string_from_file "MOVED_TO" "$list_path"

    # 处理list文件中的每一行
    while IFS= read -r line; do
        # 更新文件的修改时间
        update_file_modification_time "$line"

        # 追加文件路径到更新记录文件
        append_to_update_record "$line"

        # 删除list文件的第一行
        delete_first_line "$list_path"
    done < "$list_path"

    # 替换更新记录文件中的字符串
    replace_string_in_file "$data_path" "/" "$update_record_path"

    # 禁用文件自动标记应用
    enable_disable_app "$filescan_app"

    # 扫描更新记录文件中的文件并打印sum值
    while IFS= read -r path; do
        scan_file_and_print_sum "$path"
    done < "$update_record_path"

    # 清空更新记录文件
    clear_file "$update_record_path"

    # 启用文件自动标记应用
    enable_disable_app "$filescan_app"

    # 监听文件移动事件并记录到ilist文件
    monitor_file_movements "$data_path/admin/files/"
} 2>&1 | tee -a "$log_path"
