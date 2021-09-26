#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
N=60 #tail the last 60 lines
TO_ADDR="guoqing.ge@noaa.gov" # comma separated email addresses
INTERVAL=12 #hours 

key="RRFS.*RUNNING"

gap=99999
if [ -f $DIR/.last_date ]; then
  read last_date < $DIR/.last_date
  gap=$(( $(date -u +%s) - $(date -u -d "$last_date" '+%s') ))
fi

if [ $gap -gt $(($INTERVAL * 3600))  ]; then
  knt=$(tail -n $N $DIR/rrfsdet.log | grep "$key" | wc -l)
  lastminute=$(tail -n $N $DIR/rrfsdet.log | grep "^202" | head -n 1)
  if [ $knt -eq 0 ]; then
    text="Something is wrong with the RRFS realtime runs!!!"
    text=${text}"\nThere is no job running in since $lastminute Mountain Time\n"
    echo -e $text > $DIR/.tmp_rrfs
    tail -n $N $DIR/rrfsdet.log >> $DIR/.tmp_rrfs
    mail -s "ERROR: realtime RRFS on Jet" -r noreply.jet@noaa.gov $TO_ADDR < $DIR/.tmp_rrfs
    echo "$(date -u +'%Y%m%d %H:%M:%S')" > $DIR/.last_date
  fi
fi
