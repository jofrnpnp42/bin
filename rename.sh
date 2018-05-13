#!/bin/sh
# Usage: ./renamesh [files or directorys...]

now=`date "+%Y.%m.%d.%H.%M.%S"`
files="/tmp/tmp.rename.$$"

trap "\rm -f $files; exit 1" 1 2 15

if [ $# -eq 0 ] ; then
    echo "Syntax Error" && echo "Usage:: $0 \$@" && exit 4
fi

while [ $# != 0 ]; do
    case $1 in
         -*) echo "Could not rename: $1"
             shift ;;
          *) echo $1 >> $files
             shift ;;
    esac
done

for i in `cat $files| sed 's/\/$//g'`
do
    if [ -f ${i}.${now} ]; then     # ファイルが既に存在する場合
         \mv $i ${i}.${now}_$$
    elif [ -d ${i}.${now} ]; then   # ディレクトリが既に存在する場合
         \mv $i ${i}.${now}_$$
    elif [ -f $i ] || [ -d $i ]; then
         \mv $i ${i}.${now}
        echo "RENAME: ${i} ==> ${i}.${now}"
    else
        echo "Error!! Not Found: $i"
    fi
done

\rm -f $files

