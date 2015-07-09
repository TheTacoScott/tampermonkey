#!/bin/bash
prefix=`readlink -f $1`
movedir=`readlink -f $2`
movedir=`echo "$movedir/"`
selection=""
while true
do
  clip=`xclip -selection clipboard -o 2>/dev/null`
  tester=`echo $clip | grep -Eui "^(SELE|PLAY|MOVE|MOVV|RENA|DELE):" | wc -l`
  if [ $tester -gt 0 ]
  then
    action=`echo "$clip" | cut -d" " -f1 | cut -d":" -f1 | tr -d '\n' | tr -d '\r'`
    justclip=`echo "$clip" | cut -d" " -f2 | cut -d"|" -f1`
    uncoded=`echo "$justclip" | python -c 'import sys, urllib as ul; print ul.unquote_plus(sys.stdin.read())'`
    cleanedup=`echo "$uncoded" | sed "s/z://g" | tr '\\' '/' 2>/dev/null`
    final=`echo "$prefix$cleanedup" | sed "s/\/\//\//g" | tr -d "\n" | tr -d "\r"`
    if [ "$action" == "SELE" ]
    then
      echo "$action -- $final"
      selection=$final
    elif [ "$action" == "PLAY" ]
    then
      echo "$action -- $final"
      vlc "$final"
      echo "VLC EXIT" 
    elif [ "$action" == "MOVE" ]
    then
      directory=`zenity --file-selection --directory --filename="$movedir"`
      echo "$selection -> $directory"
    else
      echo "$action -- $selection"
    fi
    dump=`xclip -selection clipboard -i /dev/null`
  fi
  sleep 0.05
done
