# deploy.ps1（hibisaboru.github.io に置く必要はなし。どこでもOK）

# ===== Hugoビルド =====
cd ../hibisaboru.com
hugo

# ===== blogリポジトリ（= hibisaboru.com）をpush =====

if (-not (git diff --quiet)) {
  git add -A
  git commit -m "update: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
  git push origin main # 通常push。強制ではない
}

# ===== GitHub Pages用リポジトリにpublicをコピーしてpush =====
cd ../hibisaboru.github.io
Copy-Item ../hibisaboru.com/public/* -Destination . -Recurse -Force

git add -A
git commit -m "deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin main

# ===== 作業リポジトリに戻る =====
cd ../hibisaboru.com