#!/bin/bash
prefix=$1
selection=""
while true
do
  clip=`xclip -selection clipboard -o 2>/dev/null`
  tester=`echo $clip | grep -Eui "^(SELE|PLAY|MOVE|MOVV|RENA|DELE):" | wc -l`
  if [ $tester -gt 0 ]
  then
    action=`echo "$clip" | cut -d" " -f1 | cut -d":" -f1`
    justclip=`echo "$clip" | cut -d" " -f2 | cut -d"|" -f1`
    uncoded=`echo "$justclip" | python -c 'import sys, urllib as ul; print ul.unquote_plus(sys.stdin.read())'`
    cleanedup=`echo "$uncoded" | sed "s/z://g" | tr '\\' '/' 2>/dev/null`
    final=`echo "$prefix$cleanedup" | sed "s/\/\//\//g"`
    if [ "$action" == "SELE" ]
    then
      echo "$action -- $final"
      selection=$final
    elif [ "$action" == "PLAY" ]
    then
      echo "$action -- $final"
    else
      echo "$action -- $selection"
    fi
    xclip -selection clipboard -i /dev/null
  fi
  sleep 0.05
done
