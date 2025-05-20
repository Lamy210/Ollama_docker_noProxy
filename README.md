# Ollama on Docker

[![Docker Compose CI](https://github.com/yourusername/ollama-docker-setup/actions/workflows/docker-compose-ci.yml/badge.svg)](https://github.com/yourusername/ollama-docker-setup/actions/workflows/docker-compose-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

このリポジトリはOllamaをDockerコンテナ上で実行するための設定ファイルを含んでいます。Web UIとNginxリバースプロキシを組み合わせることで、使いやすいLLM（大規模言語モデル）環境を構築できます。

## コンポーネント

- **Ollama** - APIサーバー (ポート: 11434)
- **Ollama Web UI** - Webベースのユーザーインターフェース (ポート: 3000)
- **Nginx** - リバースプロキシ (ポート: 80)

## 必要条件

- Dockerおよび Docker Composeがインストールされていること

## セットアップと実行手順

1. リポジトリをクローンまたはダウンロードします

2. Docker Composeでコンテナを起動します:

```bash
docker compose up -d
```

3. モデル（例：Gemma 2B）をダウンロードします:

```bash
curl -X POST http://localhost:11434/api/pull -d '{"name": "gemma:2b"}'
```

## アクセス方法

### ローカルアクセス

- **Ollama API**: <http://localhost:11434/api>
- **Ollama Web UI（直接アクセス）**: <http://localhost:3000>
- **Ollama Web UI（Nginx経由）**: <http://localhost>

### リモートアクセス

以下のURLをサーバーのIPアドレスに置き換えてアクセスできます：

- **Ollama Web UI**: http://[サーバーのIPアドレス]
- **Ollama API**: http://[サーバーのIPアドレス]/api

例えば、サーバーのIPアドレスが188.245.109.239の場合：

- **Ollama Web UI**: <http://188.245.109.239>
- **Ollama API**: <http://188.245.109.239/api>

## モデルの使用方法

### 利用可能なモデルの確認

```bash
curl http://localhost:11434/api/tags
```

### APIを使用する場合

```bash
curl -X POST http://localhost:11434/api/generate -d '{
  "model": "gemma:2b",
  "prompt": "Pythonでフィボナッチ数列を計算する関数を書いてください"
}'
```

### チャットAPIを使用する場合

```bash
curl -X POST http://localhost:11434/api/chat -d '{
  "model": "gemma:2b",
  "messages": [
    { "role": "user", "content": "こんにちは、自己紹介してください。" }
  ]
}'
```

### サンプルスクリプトの実行

```bash
# 実行権限を付与
chmod +x ./samples/run-samples.sh

# サンプルを実行
./samples/run-samples.sh
```

サンプルディレクトリには、APIの使用例とサンプルクエリが含まれています。

## データ保存について

モデルデータは`./ollama_data`ディレクトリに保存されます。このディレクトリはDockerコンテナの`/root/.ollama`にマウントされており、コンテナを再起動してもモデルが保持されます。

## トラブルシューティング

### モデルのダウンロードに失敗する場合

```bash
docker logs ollama
```

でログを確認し、エラーメッセージを確認してください。

### Web UIにアクセスできない場合

1. コンテナが起動しているか確認:

```bash
docker ps | grep ollama
```

2. Nginxのログを確認:

```bash
docker logs ollama-nginx
```

3. Web UIのログを確認:

```bash
docker logs ollama-webui
```

### Web UIの使い方

1. ブラウザでWeb UI（http://[サーバーのIPアドレス]）にアクセス
2. 初回アクセス時に、APIのURLとして「<http://localhost/api」を設定>
3. モデルタブからダウンロード済みのモデルを確認
4. チャットタブでモデルを選択して会話を開始

### GPUを使用する場合

docker-compose.ymlファイルを編集し、以下のセクションを追加してください：

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: gpu
          capabilities: [gpu]
```

## 参考リンク

- [Ollama公式ドキュメント](https://github.com/ollama/ollama)
- [Ollama API ドキュメント](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Ollama Web UI ドキュメント](https://github.com/ollama-webui/ollama-webui)

## セキュリティに関する注意事項

このセットアップはデフォルトでは認証機能を持っていません。インターネットに公開する場合は以下の対策を検討してください：

1. **基本認証の追加**: Nginxに基本認証を設定

```bash
# htpasswdツールのインストール
apt-get update && apt-get install apache2-utils

# パスワードファイルの作成
htpasswd -c /root/ollama/.htpasswd admin

# nginx.confに以下を追加
location / {
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/.htpasswd;
    # ...その他の設定...
}
```

2. **HTTPS（SSL/TLS）の設定**: Let's Encryptなどを使用して安全な接続を確保
3. **ファイアウォールの設定**: 必要なポートのみを開放
4. **アクセス制限**: 特定のIPアドレスからのアクセスのみを許可

## 貢献方法

このプロジェクトへの貢献を歓迎します！詳細は[CONTRIBUTING.md](CONTRIBUTING.md)を参照してください。

1. このリポジトリをフォークする
2. 機能ブランチを作成する (`git checkout -b feature/amazing-feature`)
3. 変更をコミットする (`git commit -m 'Add some amazing feature'`)
4. ブランチをプッシュする (`git push origin feature/amazing-feature`)
5. プルリクエストを開く

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。
