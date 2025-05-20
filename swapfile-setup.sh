#!/bin/bash
# スワップファイルのセットアップスクリプト

# スワップファイルが存在しない場合のみ作成
if [ ! -f /swapfile ]; then
    echo "スワップファイルを作成しています..."
    dd if=/dev/zero of=/swapfile bs=1G count=4
    chmod 600 /swapfile
    mkswap /swapfile
fi

# スワップがアクティブでない場合は有効化
if ! swapon -s | grep -q /swapfile; then
    echo "スワップファイルを有効化しています..."
    swapon /swapfile
fi

# /etc/fstabにエントリが存在しない場合は追加
if ! grep -q "/swapfile" /etc/fstab; then
    echo "スワップファイルを/etc/fstabに追加しています..."
    echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
fi

echo "スワップファイルのセットアップが完了しました"
