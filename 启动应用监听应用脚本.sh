#!/bin/bash
cd "$(dirname $0)"/.. || exit 1
PROC_NAME=confcenter # 进程名 一般就是二进制的名字java类程序一般就是java
START_COMMAND='bin/confcenter' #在output目录下启动你程序的命令
PROC_PORT=8055 # 程序占用的端口，建议写，程序不占用端口的话只用ps来判断进程是否启动，机器上有同名程序是可能有问题
WAIT_TIME=60 # 执行START_COMMAND后到程序能完全启动listen端口需要花的时间
 
PROC_NAME=${PROC_NAME::15}
 
help(){
    echo "${0} <start|stop|restart|status>"
    exit 1
}
 
checkhealth(){
    if [[ -n "$PROC_PORT" ]] ; then
        PORT_PROC=$(/usr/sbin/ss -nltp "( sport = :$PROC_PORT )" |sed 1d |awk '{print $NF}' |awk -F'"' '{print $2}'|uniq)
        if [ X"$PORT_PROC" = X"$PROC_NAME" ] ; then
                echo "running"
            return 0
        fi
        echo "not running"
        return 1
   else
       ps -eo comm,pid |grep -P  "^$PROC_NAME\b"
       if [ "$?" = 0 ] ; then
       echo "running"
           return 0
       fi
       echo "not running"
       return 1
   fi
}
 
start(){
    checkhealth
    if [ $? = 0 ]; then
        echo "[WARN] $PROC_NAME is aleady running!"
        return 0
    fi
    mkdir -p log
 
    nohup $START_COMMAND  </dev/null &>> /dev/termination-log  &
 
 
    for i in $(seq $WAIT_TIME) ; do
        sleep 1
        checkhealth
        if [ $? = 0 ]; then
            echo "Start $PROC_NAME success"
            return 0
        fi
    done
    echo "[ERROR] Start $PROC_NAME failed"
    return 1
}
 
stop(){
    if [[ -n "$PROC_PORT"  ]] ; then
        PROC_ID=$(  /usr/sbin/ss -nltp "( sport = :$PROC_PORT )" |sed 1d  | awk '{print $NF}' |  grep -oP '\,.*\,' | grep -oP "\d+" |  uniq )
    else
        PROC_ID=$(ps -eo comm,pid  | grep "^$PROC_NAME\b" |awk '{print $2}')
    fi
 
    if [[ -z "$PROC_ID" ]] ; then
        echo "[WARN] $PROC_NAME is aleady exit, skip stop"
        return 0
    fi
 
    checkhealth
    if [ "$?" != "0" ] ; then
        echo "[WARN] $PROC_NAME is aleady exit, skip stop"
        return 0
    fi
    kill $PROC_ID
    for i in $(seq $WAIT_TIME) ; do
        sleep 1
        checkhealth
        if [ "$?" != "0" ] ; then
            echo "Stop $PROC_NAME success"
            return 0
        fi
    done
 
    kill -9 $PROC_ID
    sleep 1
    checkhealth
    if [ "$?" != "0" ] ; then
        echo "Stop $PROC_NAME success"
        return 0
    fi
 
    echo "[ERROR] Stop $PROC_NAME failed"
    return 1
}
 
case "${1}" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status|health|checkhealth)
        checkhealth
        ;;
    restart)
        stop && start
        ;;
    *)
        help
        ;;
esac
