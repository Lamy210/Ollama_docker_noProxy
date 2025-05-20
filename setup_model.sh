#!/bin/bash

# コンテナが起動するまで少し待機
echo "Ollamaコンテナの起動を待機しています..."
sleep 10

# gemma:2b モデルをダウンロード
echo "Gemma 2B モデルをダウンロードしています..."
curl -X POST http://localhost:11434/api/pull -d '{"name": "gemma:2b"}'

# deepseek-coder-8b-instruct モデルをダウンロード (オプション)
# echo "Deepseek Coder 8B モデルをダウンロードしています..."
# curl -X POST http://localhost:11434/api/pull -d '{"name": "deepseek-coder:8b-instruct"}'

echo "セットアップが完了しました。以下のコマンドでモデルを利用できます:"
echo "curl -X POST http://localhost:11434/api/generate -d '{\"model\": \"gemma:2b\", \"prompt\": \"あなたの質問をここに\"}'"
