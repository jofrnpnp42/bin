#!/bin/sh

CWD=`pwd`

echo 
echo "$0 start..."
echo 
sleep 0.5

test ! -n "$1"            && echo "Usage: `basename $0` [new name]"         && exit 2
TARGET="`basename $1`"  ## Target 

#--------------------------------
# ユーザIDとグループIDを指定する
#--------------------------------
U="neko"
G="neko"

#--------------------------------
# リモートリポジトリ
#--------------------------------
VAR_WWW_GIT="/var/www/git"

#--------------------------------
# HTTP公開ディレクトリとアクセス設定ファイル
#--------------------------------
VAR_WWW_HTML="/var/www/html"
ACL="/etc/apache2/sites-available/000-default.conf"
ACLD="/etc/apache2/sites-available/000-default.conf.d"
NOW=`date "+%Y%m%d%H%M%S"` 
ACLBAK="${ACLD}/`basename $ACL`.${NOW}_4_$TARGET"

# アクセス設定ファイルのバックアップディレクトリを作る
test ! -d "$ACLD" && {
    echo "# sudo mkdir $ACLD"
    sudo mkdir $ACLD
}
test ! -d "$ACLD" && echo "Error: could not sudo mkdir \$ACLD<$ACLD>"            && exit 3 


test ! -d "$VAR_WWW_GIT"  && echo "Error: could not found $VAR_WWW_GIT"     && exit 4
test ! -d "$VAR_WWW_HTML" && echo "Error: could not found $VAR_WWW_HTML"    && exit 5

GITREPO="$VAR_WWW_GIT/$TARGET.git"    ## Targe Top directory
H="hooks"          ## Hooks directory
EXE="post-receive" ## execed by hooks

#--------------------------------
# すでにリポジトリが存在していたら終了する
#--------------------------------
test -d "$GITREPO" && echo "Error: GitRepository<$GITREPO> already exists." && exit 6

#--------------------------------
# リモートリポジトリを作る
#--------------------------------
sudo mkdir $GITREPO || {
    echo "Error: could not sudo mkdir GitRepository<$GITREPO>"
    exit 7
}

echo "# cd $GITREPO" 
cd $GITREPO

echo "# sudo git --bare init --shared"
sudo git --bare init --shared 

test ! -d $GITREPO/$H && echo "Error: could not found hookdir<$GITREPO/$H>" && exit 8
sleep 0.2

#--------------------------------
# リモートリポジトリに push された時の Hook 処理を定義する. ($MARK の記述を置換する)
#--------------------------------
echo "# sudo cp -p $ACL  $ACLBAK"
sudo \cp -p $ACL  $ACLBAK 
MARK="# don't delete this line # NNR"
sudo \sed -i "s%$MARK\$%        DocumentRoot $VAR_WWW_HTML/$TARGET\n$MARK%g" $ACL
echo "$ACL was written by <$TARGET>."
# apache restart
echo "# sudo apachectl restart"
sudo apachectl restart
sleep 0.2

echo "# cd `pwd`"
cd $VAR_WWW_HTML

echo "# sudo git clone $GITREPO" ; 
sudo git clone $GITREPO
sleep 0.2
test ! -d $VAR_WWW_HTML/$TARGET && echo "Error: git clone $GITREPO was failed" && exit 9

# リモートリポジトリ作成に失敗した際の不要なファイルやディレクトリの削除
trap "
    echo \"Failure: $GITREPO was could not created.\"
    cd $VAR_WWW_GIT  && rm -rf ./$TARGET.git &&
    cd $VAR_WWW_HTML && rm -rf ./$TARGET;
    \cp -fp ${ACL}.${NOW}_4_$TARGET  $ACL; exit 10 " 1 2 3 15

sudo mkdir $VAR_WWW_HTML/$TARGET/$H
test ! -d $VAR_WWW_HTML/$TARGET/$H && echo "Error: could not sudo mkdir  $VAR_WWW_HTML/$TARGET/$H" && exit 11
cd $VAR_WWW_HTML/$TARGET/$H    ; echo "# cd $VAR_WWW_HTML/$TARGET/$H"
sudo touch  $EXE               ; echo "# sudo touch  $EXE"
sudo chmod +x $EXE             ; echo "# sudo chmod +x $EXE"
echo "# ls -l `realpath $EXE`" ; ls -l `realpath $EXE`       

test ! -f $EXE && echo "Error: could not fould $EXE" && exit 12
sudo echo '#!/bin/sh'                      >> $EXE
sudo echo "cd $VAR_WWW_HTML/$TARGET"       >> $EXE
sudo echo "sudo git --git-dir=.git pull"   >> $EXE
sudo echo                                  >> $EXE
sleep 0.1

# アクセス権の付与 (本来ならば push 専用の GID を設けるべき)
echo "# sudo chown -R $U:$G $GITREPO"
sudo chown -R $U:$G $GITREPO
echo "# sudo chown -R $U:$G $VAR_WWW_HTML/$TARGET"
sudo chown -R $U:$G $VAR_WWW_HTML/$TARGET 

#--------------------------------
# リモートリポジトリの作成が終了した
#--------------------------------
echo 
echo "Success: $GITREPO was created"
echo
sleep 0.1
echo "Let's try => git clone ssh://$U@localhost:$GITREPO"
echo 
echo "git clone ssh://$U@localhost:$GITREPO"

cd $CWD
git clone ssh://$U@localhost:$GITREPO

