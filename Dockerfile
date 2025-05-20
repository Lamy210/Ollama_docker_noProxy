FROM ollama/ollama:0.7.0

# Ollamaのデフォルトポートを公開
EXPOSE 11434

# コンテナ起動時にOllamaサーバーを起動
ENTRYPOINT ["ollama", "serve"]
