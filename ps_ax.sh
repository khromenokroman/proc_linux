#!/bin/bash
cd /proc
procs=`ls | awk '/^[0-9]+$/'`
echo PID TTY STAT TIME COMMAND > /tmp/ps_ax.txt
for proc in $procs
do
  if [ -d /proc/"$proc" ]
  then
    pid=$(awk '{print $1}' '/proc/'"$proc"'/stat')
    stat=$(awk '{print $3}' '/proc/'"$proc"'/stat')
    utime=$(awk '{print $14}' '/proc/'"$proc"'/stat')
    tty_nr=$(awk ' {print $7}' '/proc/'"$proc"'/stat')
    comm=$(awk '{print $2}' '/proc/'"$proc"'/stat')
    if ((  tty_nr > 0))
    then
    tty=$(ls -l /proc/"$proc"/fd | awk  ' { if ($9==0) print $11}')
    else
    tty=-
    fi
    command=$comm$(cat /proc/$proc/cmdline)
    echo $pid $tty $stat $utime $command >> /tmp/ps_ax.txt
  fi
done
cat /tmp/ps_ax.txt | column -t
