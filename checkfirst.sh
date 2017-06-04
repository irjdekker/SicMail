
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

filename="$workdirectory/first/list.txt"
listfile="$workdirectory/reminder/list.txt"
tempfile="$workdirectory/first/result.txt"
array=("jeroen.dekker@itility.nl" "patrick.dielesen@itility.nl" "hajo.de.groot@itility.nl" "fleur.kappen@itility.nl" "henk-jan.castermans@itility.nl" "leendert.van.duijn@itility.nl")

num_users=0
num_connected=0
num_typed=0
num_submitted=0

rm -f $listfile
echo "date,mail,connected,typed,submitted,password,length" > $tempfile

while read p; do
  organisation="false"
  connected="false"
  typed="false"
  submitted="false"
  password=""
  length="0"
  datum=""
  newdatum="n/a"

  IFS=',' read -a myarray <<< "$p"
  user="${myarray[0]}"
  mail="${myarray[1]}"

  for i in "${array[@]}"
  do
    if [ "$i" == "$mail" ] ; then
      organisation="true"
    fi
  done

  if [[ "$organisation" == "false" ]]
  then
    num_users=$(($num_users+1))

    printf -v userfile "%q" "/var/www/html/log/$mail"

    if [[ -e "$userfile" ]]
    then
      num_connected=$(($num_connected+1))
      connected="true"
      file_content=`cat $userfile`
      datum=`cat $userfile | grep "start" | head -n 1 | awk '{print $1 " " $2 " " $3 " " $4 " " $5}'`
      newdatum=$(date -d "$datum 2 hours" +'%a %b %d %T')

      if [[ $file_content =~ .*typing.* ]]
      then
        num_typed=$(($num_typed+1))
        typed="true"
        password=`cat $userfile | grep "typing" | awk '{print length, $0}' | sort -r -n | head -n 1 | cut -d" " -f10`
        length=${#password}
        datum=`cat $userfile | grep "typing" | awk '{print length, $0}' | sort -r -n | head -n 1 | awk '{print $2 " " $3 " " $4 " " $5 " " $6}'`
        newdatum=$(date -d "$datum 2 hours" +'%a %b %d %T')
      fi

      if [[ $file_content =~ .*submit.* ]]
      then
        num_submitted=$(($num_submitted+1))
        submitted="true"
        password=`cat $userfile | grep "submit" | head -n 1 | cut -d" " -f9`
        length=${#password}
        datum=`cat $userfile | grep "submit" | head -n 1 | awk '{print $1 " " $2 " " $3 " " $4 " " $5}'`
        newdatum=$(date -d "$datum 2 hours" +'%a %b %d %T')
      fi
    else
      echo "$user,$mail" >> $listfile
    fi

    echo "$newdatum,$mail,$connected,$typed,$submitted,$password,$length" >> $tempfile
  else
    echo "$user,$mail" >> $listfile
  fi
done < $filename

printf "Total number of users receiving the e-mail: $num_users\n"
printf "\n\n"
printf "*** Only browsing users ($(($num_connected-$num_typed))) ***\n\n"
cat $tempfile | grep "true,false,false" | sort -r -s -k 2M -k 3n -k 4,4
printf "\n\n"
printf "*** Only typing and not submitting users ($(($num_typed-$num_submitted))) ***\n\n"
cat $tempfile | grep "true,true,false" | sort -r -s -k 2M -k 3n -k 4,4
printf "\n\n"
printf "*** Phished users ($num_submitted) ***\n\n"
cat $tempfile | grep "true,true,true" | sort -r -s -k 2M -k 3n -k 4,4
printf "\n\n"
printf "*** Users not responding to e-mail ($(($num_users-$num_connected))) ***\n\n"
cat $tempfile | grep "false,false,false"

