
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

filename="$workdirectory/maillist.txt"

echo Starting mailing...

while read p; do 
  echo $p | awk -F"," '{system("./mail.sh \""$1 "\" \"" $2 "\"")}'
  sleep 30
done < $filename

echo End mailing!
