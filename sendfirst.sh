
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

checkfile="$workdirectory/first/start.txt"
filename="$workdirectory/first/list.txt"

if [ -f $checkfile ]; then
  rm -f $checkfile
  /usr/bin/git commit -a
  /usr/bin/git push

  echo Starting mailing...

  while read p; do
    echo $p | awk -F"," '{system("$workdirectory/first/mail.sh \""$1 "\" \"" $2 "\"")}'
    sleep 30
  done < $filename

  echo End mailing!
fi
