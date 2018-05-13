#!/bin/sh
# Usage: ./orig.sh [files or directorys...]

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
    if [ -f $i ] && [ ! -f $i.orig ]; then
          \cp -pi $i $i.orig
          echo "BACKUP: ${i}.orig"
    elif [ -f $i ]; then    ## file
          \cp -pi $i ${i}.${now}.orig
          echo "BACKUP: ${i}.${now}"
    elif [ -d $i ] && [ ! -d $i.orig ]; then  ## directory
          \cp -pri $i ${i}.orig
          echo "BACKUP: ${i}.orig"
    elif [ -d $i ]; then  ## directory
          \cp -pri $i ${i}.${now}.orig
          echo "BACKUP: ${i}.${now}.orig"
    fi
done

\rm -f $files


