#!/bin/bash

# 添加Ubuntu软件源并更新
if grep -Fxq "deb http://cz.archive.ubuntu.com/ubuntu jammy main" /etc/apt/sources.list; then
    echo "行已存在，不需要再添加。"
else
    echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
    apt update
    echo "行已成功添加。"
fi

# 检查libc6是否已安装
if dpkg -s libc6 &> /dev/null; then
    echo "libc6已安装，不需要再次安装。"
else
    apt install libc6 -y
    echo "libc6已成功安装。"
fi

# 检查g++-11是否已安装
if dpkg -s g++-11 &> /dev/null; then
    echo "g++-11已安装，不需要再次安装。"
else
    apt install -y g++-11
    echo "g++-11已成功安装。"
fi

# 检查screen是否已安装
if dpkg -s screen &> /dev/null; then
    echo "screen已安装，不需要再次安装。"
else
    apt install -y screen
    echo "screen已成功安装。"
fi

# 创建目录，下载并解压文件
directory="/root/q"
if [ -d "$directory" ]; then
    echo "目录已存在，不需要再次创建。"
else
    mkdir "$directory"
    echo "目录创建成功。"
fi

# 进入目录
cd "$directory"

# 定义文件URL和MD5哈希值
file_url="https://github.com/dingrongbao/push/blob/main/FKX1MyExyoUrxZfgMmNnQ0/qli-Client"
remote_md5=$(wget -qO- "$file_url" | md5sum | awk '{print $1}')


# 定义本地文件名
local_file="qli-Client"

# 检查本地文件是否存在
if [ -e "$local_file" ]; then
    # 获取本地文件的MD5哈希值
    local_md5=$(md5sum "$local_file" | awk '{print $1}')

    # 比较MD5哈希值
    if [ "$local_md5" == "$remote_md5" ]; then
        echo "本地文件已存在且MD5哈希值匹配，无需重新下载。"
    else
        echo "本地文件存在，但MD5哈希值不匹配，可能文件已被篡改。删除现有文件并重新下载。"
        rm "$local_file"
        wget "$file_url"
        echo "下载完成。"
    fi
else
    # 文件不存在，直接下载
    echo "本地文件不存在，开始下载。"
    wget "$file_url"
    echo "下载完成。"
fi


# 设置变量
name="XX$(cat ~/.vast_containerlabel | awk -F. '{print $2}')"
new_json_data='{ "Settings": { "baseUrl": "https://ai.diyschool.ch/", "amountOfThreads": 96, "payoutId": null, "accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImVhMWM5MzFlLWI3MTMtNDZhYS04ZTQ3LWE3ZWY1ODkzY2Q1YiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwMzIwMzQ2MCwiZXhwIjoxNzM0NzM5NDYwLCJpYXQiOjE3MDMyMDM0NjAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.aUIqBn821GL_a3R8TQ4S8Pej1861C59P04G2-FMEzGlKX3a5DMwsflmiTmHYuxqUnuWsFaWgN2hgcxqwszjj4g", "alias": "'"$name"'", "allowHwInfoCollect": true } }'

# 指定JSON文件路径
json_file="/root/q/appsettings.json"

# 检查文件是否已经存在
if [ -e "$json_file" ]; then
    # 检查内容是否相同
    if cmp -s <(echo "$new_json_data") "$json_file"; then
        echo "文件内容相同，不需要再次写入。"
    else
        # 写入新的JSON数据
        echo -e "$new_json_data" > "$json_file"
        echo "文件内容更新成功。"
    fi
else
    # 文件不存在，直接写入
    echo -e "$new_json_data" > "$json_file"
    echo "文件写入成功。"
fi

# 定义screen会话名称
screen_session="q"

# 检查是否存在同名的screen会话
if pgrep -x "screen" > /dev/null; then
    if screen -list | grep -q "$screen_session"; then
        # 获取screen会话状态
        session_status=$(screen -list | grep "$screen_session" | awk '{print $3}')

        if [ "$session_status" == "Detached" ]; then
            echo "名为 $screen_session 的 screen 会话已存在并处于 Detached 状态。重新启动程序..."
            # 如果存在同名的screen会话且状态是Detached，重新启动程序
            screen -X -S "$screen_session" quit
            chmod +x "./qli-Client"
            screen -dmS "$screen_session" ./qli-Client
            echo "重新启动名为 $screen_session 的 screen 会话成功。"
            exit 0
        else
            echo "名为 $screen_session 的 screen 会话存在，但状态不是 Detached。"
        fi
    else
        # 如果不存在同名的screen会话，则创建新的会话
        chmod +x "./qli-Client"
        screen -dmS "$screen_session" ./qli-Client
        echo "创建名为 $screen_session 的 screen 会话成功。"
    fi
else
   
