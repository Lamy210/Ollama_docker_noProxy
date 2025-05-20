#!/bin/bash

# サンプルクエリの使い方を示すスクリプト
echo "=== Ollama APIサンプル ==="

echo -e "\n1. 利用可能なモデルを確認"
curl http://localhost:11434/api/tags

echo -e "\n\n2. チャットAPIの使用例"
curl -X POST http://localhost:11434/api/chat -d @./samples/sample-chat.json

echo -e "\n\n3. 生成APIの使用例"
curl -X POST http://localhost:11434/api/generate -d @./samples/sample-generate.json

echo -e "\n\n4. Web UIはブラウザから http://localhost または http://localhost:3000 でアクセスできます"
