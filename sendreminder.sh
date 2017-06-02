
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

checkfile="$workdirectory/reminder/start.txt"
filename="$workdirectory/reminder/list.txt"

if [ -f $checkfile ]; then
  rm -f $checkfile
  /usr/bin/git commit -a -m "Commit"
  /usr/bin/git push

  echo Starting mailing... > $workdirectory/sendreminder.log

  while read p; do
    echo $p | awk -F"," '{system("$./reminder/mail.sh \""$1 "\" \"" $2 "\"")}' >> $workdirectory/sendreminder.log
    sleep 30
  done < $filename

  echo End mailing! >> $workdirectory/sendreminder.log
fi
