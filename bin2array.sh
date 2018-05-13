#!/bin/sh
# BINARY HACKS (オライリー社) の #4 より引用している。

Usage() {
    echo "Usage 1: ./bin2array.sh  [input-file]"
    echo "Usage 2: ./bin2array.sh  [input-file]  [objname]"
}

test   -z "$1" && Usage && exit 4
test ! -f "$1" && Usage && exit 4

objname=${2:-objname} # 第一引数がなければ "objname" という文字列を設定

od -A n -v -t x1 $1 | sed -e '1i\
const unsigned char '$objname'[] = {
s/\([0-9a-f][0-9a-f]\) */0x\1,/g
$s/,$//
$a\
};
'

