#!/bin/bash
prefix=`readlink -f $1`
movedir=`readlink -f $2`
movedir=`echo "$movedir/"`
deledir=`readlink -f $3`
deledir=`echo "$deledir/"`
testfile=$4
selectiondir=""
selection=""
helpername=""
while true
do
  clip=`xclip -selection clipboard -o 2>/dev/null`
  tester=`echo $clip | grep -Eui "^(SELE|PLAY|MOVE|MOVV|RENA|DELE|PREF):" | wc -l`
  action=`echo "$clip" | cut -d" " -f1 | cut -d":" -f1 | tr -d '\n' | tr -d '\r'`
  if [ $tester -gt 0 ]
  then
    if [ "$action" == "PREF" ]
    then
      final=`echo "$clip" | cut -d":" -f2`
    else
      justclip=`echo "$clip" | cut -d" " -f2 | cut -d"|" -f1`
      uncoded=`echo "$justclip" | python -c 'import sys, urllib as ul; print ul.unquote_plus(sys.stdin.read())'`
      cleanedup=`echo "$uncoded" | sed "s/z://g" | tr '\\' '/' 2>/dev/null`
      final=`echo "$prefix$cleanedup" | sed "s/\/\//\//g" | tr -d "\n" | tr -d "\r"`
    fi
    if [ ! -f "$testfile" ]
    then
      echo "NO TEST FILE"
      exit 1
    fi

    
    if [ "$action" == "PREF" ]
    then
      helpername=$final
      echo "$action -- $helpername"
    elif [ "$action" == "SELE" ]
    then
      selection=$final
      echo "$action -- $selection"
    elif [ "$action" == "PLAY" ]
    then
      echo "$action -- $final"
      vlc --http-port=9999 "$final"
      echo "VLC EXIT" 
    elif [ "$action" == "MOVE" ]
    then
      directory=`zenity --file-selection --directory --filename="$movedir" 2>/dev/null`
      directory=`echo "$directory/"`
      if [ -d "$directory" ]
      then
        selectiondir=$directory
        valid=`echo "$directory" | grep "$movedir" | wc -l`
        if [ $valid -gt 0 ]
        then
          result=`mv -v "$selection" "$directory" | sed "s/ -> /\n\nMoved To:\n\n/g"`
          zenity --info --text="$result" --timeout=2
        fi
        
      fi
    elif [ "$action" == "MOVV" ]
    then
      result=`mv -v "$selection" "$selectiondir" | sed "s/ -> /\n\nMoved To:\n\n/g"`
      zenity --info --text="$result" --timeout=2
    elif [ "$action" == "DELE" ]
    then
      echo "$action -- $selection"
      result=`zenity --question --text="Delete File?" --default-cancel 2>/dev/null; echo $?`
      if [ $result -eq 0 ]
      then
        result=`mv -v "$selection" "$deledir" | sed "s/ -> /\n\nDelete / Moved To:\n\n/g"`
        zenity --info --text="$result" --timeout=2
      fi
    elif [ "$action" == "RENA" ]
    then
      echo "$action -- $selection"
      newhelpername=`zenity --entry --text="Prefix" --entry-text="$helpername" --width=800`
      if [ $? -eq 0 ]
      then
        helpername=`echo "$newhelpername"`
        curdir=`dirname "$selection"`
        justfile=`basename "$selection"`
        md5=`echo "$justfile" | grep -Eio "\[[0-9a-f]{32}\]"`
        ext="${justfile##*.}"
        base=`echo "$justfile" | sed 's/.*/\L&/; s/[a-z]*/\u&/g' | sed "s/$helpername//g" | grep -Pio "^.*(?= \[[0-9a-f]{32}\])"`
        newbase=`zenity --entry --text="$helpername" --entry-text="$base" --width=800`
        if [ $? -eq 0 ]
        then
          newfilename=`echo "$curdir/$helpername ($newbase) $md5.$ext"`
          result=`mv -v "$selection" "$newfilename" | sed "s/ -> /\n\nRenamed To:\n\n/g"`
          zenity --info --text="$result" --timeout=2
        fi
      fi
    else
      echo "$action -- $selection"
    fi


    dump=`xclip -selection clipboard -i /dev/null`
  fi
  sleep 0.05
done
