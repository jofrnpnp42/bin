#!/bin/sh

#--------------------------------
# リモートリポジトリ
#--------------------------------
VAR_WWW_GIT="/var/www/git"

#--------------------------------
# HTTP公開ディレクトリとアクセス設定ファイル
#--------------------------------
VAR_WWW_HTML="/var/www/html"
ACL="/etc/apache2/sites-available/000-default.conf"

test ! -n "$1"            && echo "Usage: `basename $0` [new name]"         && exit 2
TARGET="`basename $1`"  ## Target 

cd $VAR_WWW_GIT  && rm -rf ./$TARGET.git
cd $VAR_WWW_HTML && rm -rf ./$TARGET;
\sed -i "\\@DocumentRoot $VAR_WWW_HTML/$TARGET@d" $ACL || {
    echo "Error: sed failed." 
    exit 3
}
echo "delete: \"DocumentRoot $VAR_WWW_HTML/$TARGET\" from $ACL"
