#!/bin/bash
# Usage: ./do_ffill.sh  -s 32  -c 64  a.txt
# hoge.txt の 32バイト目から64バイト分を 0 埋めする

usage() {
echo "Usage: $0 -s [seek bytes] -c [count] [file]" 
}

while getopts s:c: OPTION
do
   case $OPTION in
       s) SEEK="$OPTARG"
          [ "$SEEK" -lt 0 ] && echo "$SEEK: seek size error" && exit 2 ;;
       c) COUNT="$OPTARG"
          [ "$COUNT" -lt 0 ] && echo "$COUNT: seek size error" && exit 2 ;;
      \?) echo "$USAGE" 1>&2
          echo XXX
          exit 1 ;;
       *) ;;
    esac
done

readonly IF="/dev/zero"
readonly CONV="notrunc"

test -z "$SEEK"   && echo "\$SEEK is NULL"  && usage && exit 2
test -z "$COUNT"  && echo "\$COUNT is NULL" && usage && exit 2

shift `expr $OPTIND - 1` # check argument

[ $# -lt 0 ] && echo "ERROR: not found $1" && exit 0
FILE=$1
( [ ! -z "$FILE" ] && [ ! -f "$FILE" ] ) && echo "$FILE: No such file" && exit 2

\dd if="$IF" of="$FILE" bs=1 seek="$SEEK" count="$COUNT" conv=$CONV

