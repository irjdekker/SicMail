#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

echo "Sending mail to $1 ($2)"

from="Fleur Kappen <fleur.kappen@itlity.nl>"
to="$2"
subject=`echo 'Input gevraagd voor Sicilië workshop' | openssl base64`

(
echo "From: $from"
echo "To: $to"
echo "MIME-Version: 1.0"
echo "Subject: =?UTF-8?B?$subject?="
echo 'Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"'
echo ""
echo "--GvXjxJ+pjyke8COw"
echo "Content-Type: text/plain; charset=UTF-8"
echo ""
cat $workdirectory/mail.txt | sed "s/!!!/$1/" | sed "s/###/$2/"
echo ""
echo "--GvXjxJ+pjyke8COw"
echo "MIME-Version: 1.0"
echo 'Content-Type: multipart/related; type="text/html"; start="mailbody"; boundary="wOC8ekyjp+JxjXvG"'
echo ""
echo "--wOC8ekyjp+JxjXvG"
echo "Content-Type: text/html; charset=UTF-8"
echo "Content-Disposition: inline"
echo "Content-ID: mailboxy"
echo ""
cat $workdirectory/mail.html | sed "s/!!!/$1/" |  sed "s/###/$2/"
echo ""
echo "--wOC8ekyjp+JxjXvG"
echo "Content-Type: image/png"
echo "Content-ID: image002.png"
echo "Content-Disposition: attachment; filename=\"image002.png\""
echo "Content-Transfer-Encoding: base64"
echo ""
openssl base64 < $workdirectory/image002.png
echo ""
echo "--wOC8ekyjp+JxjXvG"
echo "Content-Type: image/png"
echo "Content-ID: image003.png"
echo "Content-Disposition: attachment; filename=\"image003.png\""
echo "Content-Transfer-Encoding: base64"
echo ""
openssl base64 < $workdirectory/image003.png
echo ""
echo "--wOC8ekyjp+JxjXvG"
echo "Content-Type: image/png"
echo "Content-ID: image005.png"
echo "Content-Disposition: attachment; filename=\"image005.png\""
echo "Content-Transfer-Encoding: base64"
echo ""
openssl base64 < $workdirectory/image005.png
) | /usr/sbin/sendmail -t 
