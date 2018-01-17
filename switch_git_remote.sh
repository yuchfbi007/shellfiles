#!/bin/bash

#
# 一键切换git远程地址
#
LOCAL_PATH=
REMOTE_URL=

show_help() {
    cat <<EOF >&2
切换本地git仓库的远端地址
Usage:  $0 [-l LOCAL_PATH] [-r REMOTE_URL]
    -l LOCAL_PATH
        本地地址
    -r REMOTE_URL
        远端地址
    -h help
Example:  $0 -l /path/to/repo -r http://git.s.com/xxx/xxx.git
EOF
}

confirm() {
    read -r -p "${1}? [y/N]:" response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

check_dir_exist(){
    if [[ ! -d "$LOCAL_PATH" ]];then
        echo "本地目录[$LOCAL_PATH]不存在"
        exit 1
    fi
}

check_remote_url(){
    if [[ ! ${REMOTE_URL} =~ ^(git\@(.+):|http(s?):\/\/)(.+)(\.git)$ ]];then
        echo "格式错误"
        exit 1
    fi
}

switch_repo(){
    git remote remove origin && git remote add origin "$1"
}

main_process(){
    check_dir_exist
    check_remote_url
    TARGET_DIR_NAME=${REMOTE_URL##*\/}
    TARGET_DIR_NAME=${TARGET_DIR_NAME%".git"}
    cd ${LOCAL_PATH} && \
     confirm "确定切换地址吗" && \
     switch_repo ${REMOTE_URL} && \
     confirm "是否更改目录名为[$TARGET_DIR_NAME]" && \
     mv "${LOCAL_PATH}" "$LOCAL_PATH/../$TARGET_DIR_NAME" && \
     echo "操作成功"
    exit 0
}

## exec

while getopts "l:r:h" opt; do
    case $opt in
        l)
            LOCAL_PATH="$OPTARG"
            ;;
        r)
            REMOTE_URL="$OPTARG"
            ;;
        h)
            show_help
            ;;
        \?)
            exit 1
            ;;
        :)
            exit 1
            ;;
    esac
done

main_process
