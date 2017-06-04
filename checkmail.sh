#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

from="Poll Update <no-reply@itlity.nl>"
to="jeroen.dekker@itility.nl"
subject="Poll Update"

(
echo "From: $from"
echo "To: $to"
echo "MIME-Version: 1.0"
echo "Subject: $subject"
echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<head>"
echo "<title>Pull Update</title>"
echo "</head>"
echo "<body>"
cat $workdirectory/check_output.txt | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/<br>\n/g' | sed -e 's/,/, /g'
echo "</body>"
) | /usr/sbin/sendmail -t
