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
echo "Content-Type: text/plain"
echo ""
cat $workdirectory/check_output.txt
) | /usr/sbin/sendmail -t
