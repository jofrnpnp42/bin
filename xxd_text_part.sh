#!/bin/sh

test   -z "$1" && echo "Usage: `basename $0` [file]" && exit 2
test ! -f "$1" && echo "Error: $1 was not found"     && exit 2

xxd $1 |
awk ' BEGIN {
    i = 0
    buff[NR] = 0
}
{
    # パターンに一致しない場合は最終行と見なす
    if( match($0, /^[a-fA-F0-9]{8}:( [a-fA-F0-9]{4}){8}( ){2}(.+)/) ) {
        sub(/  /, "\t\t", $0)
        $0 = gensub( /(.+)\t\t(.+)/ , "\\2", 1, $0 )
#       buff[i++] = $0
        printf("%s", $0)
    }
    else if( match($0, /^[ \t]*$/) ) {
        # 空行であればファイルの終端に達したとみなす
        exit(0)
    }
    else {
        # 非空行、かつ、パターン不一致であれば最終行として END に進む
        exit(0)
    }
}
END {
    # 最終行は半角スペース2個を区切りと見なして第2フィールドを取り出す
    buff[i++] = gensub(/(.+)  (.+)/, "\\2", "G", $0)
    for( n = 0; n < i; n++ ) {
        print(buff[n])
    }
}'
