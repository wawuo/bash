#!/bin/bash
# 指明运行该脚本的解释器为 Bash

SCRIPT_NAME="/tmp/filescan/filescan.sh"  # 填写需要检测和启动的脚本名称（请修改为实际脚本路径）
PIDS=`ps -ef | grep -v grep | grep ${SCRIPT_NAME} | awk '{print $2}'`

if [ "${PIDS}" = "" ]; then
    echo "Script ${SCRIPT_NAME} is not running. Starting it now..."
    ${SCRIPT_NAME}  # 填写实际脚本的路径和名称
else
    echo "Script ${SCRIPT_NAME} is running with PID: ${PIDS}"
fi
