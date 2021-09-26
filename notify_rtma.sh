#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
N=1200 #tail the last 1000 lines
TO_ADDR="guoqing.ge@noaa.gov" # comma separated email addresses
INTERVAL=12 #hours 

key="RTMA.*RUNNING"

gap=99999
if [ -f $DIR/.last_date_rtma ]; then
  read last_date < $DIR/.last_date_rtma
  gap=$(( $(date -u +%s) - $(date -u -d "$last_date" '+%s') ))
fi

if [ $gap -gt $(($INTERVAL * 3600))  ]; then
  knt=$(tail -n $N $DIR/rrfsdet.log | grep "$key" | wc -l)
  if [ $knt -eq 0 ]; then
    text="Something is wrong with the RTMA realtime runs!!!"
    text=${text}"\nThere is no job running in more than 3 hours\n"
    echo -e $text > $DIR/.tmp_rtma
    tail -n $N rrfsdet.log | head -n 20 >> $DIR/.tmp_rtma
    mail -s "ERROR: realtime RTMA on Jet" -r noreply.jet@noaa.gov $TO_ADDR < $DIR/.tmp_rtma
    echo "$(date -u +'%Y%m%d %H:%M:%S')" > $DIR/.last_date_rtma
  fi
fi
