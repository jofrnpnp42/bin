#!/bin/sh
# Usage: ./mda.sh [new dir]
# 引数名＋時刻情報としてディレクトリを作る
# ex) $0 hoge -> mkdir hoge.`date +"%Y.%m.%d.%H.%M.%S"`

case $# in
    1) 
        if [ $1 = '/' ] || [ $1 = '//' ] ; then
            echo "Cancel: $1 is root directory"
            exit 0
        fi

        now=`date +"%Y.%m.%d.%H.%M.%S"`
        newdir=`echo $1.$now | sed 's/\/\//\//g'`
        [ -d $newdir ] && echo "$1 is already existing" && exit 1
        mkdir $newdir 
        echo $newdir;;

    *)  echo "Syntax Error!!"
        echo "Usage: $0  [dir-name]" 
            exit 1 ;;
esac ;

