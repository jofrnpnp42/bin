#!/bin/bash
echo 'setting ibus-mozc...'
 
# ibus-mozcのデフォルト入力モード対策
# 日本語 (Mozc)に切り替えて全角キーを送信し英語 (US)に戻す
sleep 1 && \
xdotool keydown alt && sleep 0.2 && \
xdotool key grave && sleep 0.2 && \
xdotool keyup alt && \
for i in `seq 0 9`
do
  mozc=`ps -ef | grep 'ibus-engine-mozc' | grep -v grep | grep -v srvchk | wc -l`
  if [ $mozc -gt 0 ]; then
    sleep 1
    xdotool keydown Zenkaku && sleep 0.2 && \
    xdotool keyup Zenkaku && sleep 0.2
    break
  else
    sleep 1
  fi
done
sleep 0.2 && \
xdotool keydown alt && sleep 0.2 && \
xdotool key grave && sleep 0.2 && \
xdotool keyup alt
 
echo 'ibus-mozc setting done.'
 
 
sleep 1

