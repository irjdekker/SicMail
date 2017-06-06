
#!/bin/bash
workdirectory=`dirname "$(readlink -f "$0")"`

$workdirectory/sendfirst.sh
#$workdirectory/sendreminder.sh
