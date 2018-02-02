#!/bin/bash

MAX_DISK_SPACE=60
MAX_DAYS=15


LOG_PATH=/export/Logs/
#86400s
day=86400
cts=$(date +%s)
cts=$(( cts/day * day ))

cleanup() {
    day_num=$1
    find $LOG_PATH -maxdepth 2 -type f -name '*.log.*' | while read logfile
    do
	filesize=`du -lh  $logfile`
	echo "file size :$filesize"

        date_str=$(echo $logfile | awk -F. '{print $NF}')
        lts=$(date --date $date_str +%s)
        log_day_num=$(( (cts-lts)/day ))
        (( log_day_num >= day_num)) && rm -f $logfile
    done
}

cleanup1() {
    day_num=$1
    find $LOG_PATH -maxdepth 3 -type f -name '*.*.log' | while read logfile
    do
	filesize=`du -lh  $logfile`
	echo "file size :$filesize"

        date_str=$(echo $logfile | awk -F. '{print $(NF-2)}')
        lts=$(date --date $date_str +%s)
        log_day_num=$(( (cts-lts)/day ))
        (( log_day_num >= day_num)) && rm -f $logfile
    done
}

#for catalina_out in /export/Packages/*/latest/logs/catalina.out
#do
#    test -f $catalina_out && cat /dev/null >$catalina_out
#done

for (( i=MAX_DAYS;i>=1;i--))
do
    disk_space=$(df /export | awk  '$NF=="/export"{print $(NF-1)}' | sed 's/%//g')
    (( disk_space > MAX_DISK_SPACE )) && cleanup $i && cleanup1 $i 
done
