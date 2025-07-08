# deploy.ps1（hibisaboru.github.io に置く必要はなし。どこでもOK）

# Hugoプロジェクト → デプロイ先に直接出力
hugo -s ../hibisaboru.com -d ../hibisaboru.github.io

# デプロイ先でgit操作
cd ../hibisaboru.github.io
git add -A
git commit -m "Deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin main
cd ../hibisaboru.com