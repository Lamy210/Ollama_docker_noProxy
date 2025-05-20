#!/bin/bash

# ヘルパー関数 - モデルのインストール状態をチェックする
check_model() {
  local model_name=$1
  echo "モデル $model_name のインストール状態を確認中..."
  
  # モデルがインストール済みか確認
  if curl -s http://localhost:11434/api/tags | grep -q "$model_name"; then
    echo "モデル $model_name は既にインストールされています"
    return 0
  else
    echo "モデル $model_name はインストールされていません"
    return 1
  fi
}

# ヘルパー関数 - モデルをインストールする
install_model() {
  local model_name=$1
  echo "モデル $model_name をインストール中..."
  
  # モデルをインストール
  curl -X POST http://localhost:11434/api/pull -d "{\"name\": \"$model_name\"}"
  
  # インストール完了を待機
  echo "インストールが完了するまで待機中..."
  sleep 5
  
  # インストールの確認
  if check_model "$model_name"; then
    echo "モデル $model_name のインストールが完了しました"
  else
    echo "モデル $model_name のインストールに失敗しました"
  fi
}

# メイン処理
echo "Ollamaモデルインストールスクリプトを開始します"

# 既存のモデルを確認
echo "インストール済みのモデル:"
curl -s http://localhost:11434/api/tags

# モデルのインストール
if ! check_model "gemma:2b"; then
  install_model "gemma:2b"
fi

if ! check_model "llama3:8b"; then
  install_model "llama3:8b"
fi

if ! check_model "mistral:7b"; then
  install_model "mistral:7b"
fi

# コンテナの再起動
echo "コンテナを再起動しています..."
cd /root/ollama && docker compose restart

echo "完了しました！Web UIから利用可能なモデルを確認してください"
