
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

filename="$workdirectory/check_output.txt"
tempfile="$workdirectory/check_output.tmp"
$workdirectory/checkfirst.sh > $tempfile

if ! cmp $filename $tempfile >/dev/null 2>&1
then
  rm -f $filename
  mv $tempfile $filename
  $workdirectory/checkmail.sh
else
  rm -f $tempfile
fi

