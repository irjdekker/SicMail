
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

filename="$workdirectory/first/list.txt"
listfile="$workdirectory/reminder/list.txt"
tempfile="$workdirectory/first/result.txt"

num_users=0
num_connected=0
num_typed=0
num_submitted=0

rm -f $listfile
echo "mail,connected,typed,submitted,password,length" > $tempfile

while read p; do
  connected="false"
  typed="false"
  submitted="false"
  password=""
  length="0"

  num_users=$(($num_users+1))

  IFS=',' read -a myarray <<< "$p"
  user="${myarray[0]}"
  mail="${myarray[1]}"

  printf -v userfile "%q" "/var/www/html/log/$mail"

  if [[ -e "$userfile" ]]
  then
    num_connected=$(($num_connected+1))
    connected="true"
    file_content=`cat $userfile`

    if [[ $file_content =~ .*typing.* ]]
    then
      num_typed=$(($num_typed+1))
      typed="true"
      password=`cat $userfile | grep "typing" | awk '{print length, $0}' | sort -r -n | head -n 1 | cut -d" " -f10`
      length=${#password}
    fi

    if [[ $file_content =~ .*submit.* ]]
    then
      num_submitted=$(($num_submitted+1))
      submitted="true"
      password=`cat $userfile | grep "submit" | head -n 1 | cut -d" " -f9`
      length=${#password}
    fi
  else
    echo "$user,$mail" >> $listfile
  fi

    echo "$mail,$connected,$typed,$submitted,$password,$length" >> $tempfile
done < $filename

echo "Total number of users receiving the e-mail: $num_users"
echo ""
echo "*** Only browsing users ($(($num_connected-$num_typed))) ***"
cat $tempfile | grep "true,false,false"
echo ""
echo "*** Only typing / not submitting users ($(($num_typed-$num_submitted))) ***"
cat $tempfile | grep "true,true,false"
echo ""
echo "*** Phished users ($num_submitted)***"
cat $tempfile | grep "true,true,true"
echo ""
echo ""
echo "*** Users not responding to e-mail ($(($num_users-$num_connected))) ***"
cat $tempfile | grep "false,false,false"

