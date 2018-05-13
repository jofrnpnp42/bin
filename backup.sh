#!/bin/sh
# Usage: ./backup.sh [files or directorys...]

now=`date "+%Y.%m.%d.%H.%M.%S"`
files="/tmp/tmp.rename.$$"

[ -f "$files" ] && echo "$files is already existance. exit..." && exit 2

trap "rm -f $files; exit 1" 1 2 15

\touch $files

while [ $# != 0 ]; do
    case $1 in
          -*) echo "Could not rename: $1"
              shift ;;
          */) echo $1 | sed 's/\/$//g' >> $files
              shift;;
           *) echo $1 >> $files
              shift ;;
    esac
done

for i in `cat $files`
do
    if [ -f $i ]; then    ## file
          \cp -pi $i ${i}.${now}
          echo "BACKUP: ${i}.${now}"
    elif [ -d $i ]; then  ## directory
          \cp -pri $i ${i}.${now}
          echo "BACKUP: ${i}.${now}"
    fi
done

\rm -f $files

