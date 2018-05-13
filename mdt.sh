#!/bin/sh
# Usage 1: ./mdt.sh          #    ./temp.2010.12.34.56.54.32 というディレクトリを作成する
# Usage 2: ./mdt.sh  /tmp/   # /tmp/temp.2010.12.34.56.54.32 というディレクトリを作成する

case $# in
    0)  
        now=`date +"%Y.%m.%d.%H.%M.%S"`
        mkdir temp.$now
        echo temp.$now
        exit 0 ;;
    1) 
        [ -f $1 ] && echo "Error!! $1 is already existing and file" && exit 1

        if [ $1 = '/' ] || [ $1 = '//' ] ; then
            echo "Cancel: $1 is root directory"
            exit 0
        fi

        now=`date +"%Y.%m.%d.%H.%M.%S"`
        newdir=`echo $1/temp.$now | sed 's/\/\//\//g'`
        [ -d $newdir ] && echo "$1 is already existing" && exit 1
        mkdir $newdir
        echo $newdir ;;
    *)  
        echo "Syntax Error!!"
        echo "Usage: $0  [dir-path]" 
        exit 1 ;;
esac ;

