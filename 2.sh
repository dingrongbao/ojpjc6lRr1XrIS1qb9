#!/bin/bash

if dpkg -s cron &> /dev/null; then
    echo "cron已安装，不需要再次安装。"
else
    apt install cron -y
    echo "cron已成功安装。"
fi

if grep -Fxq "*/10 * * * * root /root/1.sh" /etc/crontab; then
    echo "crontab 行已存在，不需要再添加。"
else
    echo "*/10 * * * * root /root/1.sh" >> /etc/crontab
    echo "crontab 行已成功添加。"
fi



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

# 创建目录 q
directory="/root/q"
if [ -d "$directory" ]; then
    echo "目录已存在，不需要再次创建。"
else
    mkdir "$directory"
    echo "目录创建成功。"
fi

directory2="/root/q2"
if [ -d "$directory2" ]; then
    echo "目录已存在，不需要再次创建。"
else
    mkdir "$directory2"
    echo "目录创建成功。"
fi
# 进入目录

cd "$directory"

# 定义文件URL和MD5哈希值
file_url="https://dl.qubic.li/downloads/qli-Client-1.7.9.2-Linux-x64.tar.gz"
remote_md5=$(wget -qO- "$file_url" | md5sum | awk '{print $1}')


# 定义本地文件名
local_file="qli-Client-1.7.9.2-Linux-x64.tar.gz"

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
        tar zxvf qli-Client-1.7.9.2-Linux-x64.tar.gz
        cp -rf qli-Client /root/q2/
        pkill screen
    fi
else
    # 文件不存在，直接下载
    echo "本地文件不存在，开始下载。"
    wget "$file_url"
    echo "下载完成。"
    tar zxvf qli-Client-1.7.9.2-Linux-x64.tar.gz
    cp -rf qli-Client /root/q2/
    pkill screen
fi


# 设置变量
name="XX$(cat ~/.vast_containerlabel | awk -F. '{print $2}')"
new_json_data='{ "Settings": { "baseUrl": "https://ai.diyschool.ch/", "amountOfThreads": 96, "payoutId": null, "accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImVhMWM5MzFlLWI3MTMtNDZhYS04ZTQ3LWE3ZWY1ODkzY2Q1YiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwMzIwMzQ2MCwiZXhwIjoxNzM0NzM5NDYwLCJpYXQiOjE3MDMyMDM0NjAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.aUIqBn821GL_a3R8TQ4S8Pej1861C59P04G2-FMEzGlKX3a5DMwsflmiTmHYuxqUnuWsFaWgN2hgcxqwszjj4g", "alias": "'"$name"'", "overwrites": {"CUDA": "12"} } }'

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



# 设置变量
cpuThreads=`cat /proc/cpuinfo| grep "processor"| wc -l`
cpuThreads2=$((cpuThreads-6))
name="2XX$(cat ~/.vast_containerlabel | awk -F. '{print $2}')"
new_json_data2='{ "Settings": { "baseUrl": "https://mine.qubic.li/", "amountOfThreads": "'"cpuThreads2"'", "payoutId": null, "accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6Ijg4MjE2ZmIyLTc3MzMtNDY2Ny1hMzQ0LTQ5ZjAyYTVmZGIyMSIsIk1pbmluZyI6IiIsIm5iZiI6MTY5ODQ3MDg4OSwiZXhwIjoxNzMwMDA2ODg5LCJpYXQiOjE2OTg0NzA4ODksImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.opc1svKYKSj5J9JHssFmF39lchH13RJ3IG81sFQgx9-1XygCR0STj7SuP5_yXdYWgQPAra3pEb7czqJjFxYYNQ", "alias": "'"$name"'", "allowHwInfoCollect": true } }'

# 指定JSON文件路径
json_file="/root/q2/appsettings.json"

# 检查文件是否已经存在
if [ -e "$json_file" ]; then
    # 检查内容是否相同
    if cmp -s <(echo "$new_json_data2") "$json_file"; then
        echo "文件内容相同，不需要再次写入。"
    else
        # 写入新的JSON数据
        echo -e "$new_json_data2" > "$json_file"
        echo "文件内容更新成功。"
    fi
else
    # 文件不存在，直接写入
    echo -e "$new_json_data2" > "$json_file"
    echo "文件写入成功。"
fi





screen -ls | grep -q "wipe" && screen -wipe

if ! screen -ls|grep q1 > /dev/null; then
		screen -L -Logfile /run/q1.log -dmS q1 ./qli-Client
fi


cd /root/q2
if ! screen -ls|grep q2 > /dev/null; then
		screen -L -Logfile /run/q2.log -dmS q2 ./qli-Client
fi





