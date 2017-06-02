
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

checkfile="$workdirectory/first/start.txt"
filename="$workdirectory/first/list.txt"

if [ -f $checkfile ]; then
  rm -f $checkfile
  /usr/bin/git commit -a -m "Commit"
  /usr/bin/git push

  echo Starting mailing... > $workdirectory/sendfirst.log

  while read p; do
    echo $p | awk -F"," '{system("./first/mail.sh \""$1 "\" \"" $2 "\"")}' >> $workdirectory/sendfirst.log
    sleep 30
  done < $filename

  echo End mailing! >> $workdirectory/sendfirst.log
fi
