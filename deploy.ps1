# deploy.ps1（blogフォルダに置き、blogから実行する）

# ===== Hugoビルド =====
cd ..
cd ./blog
hugo

# ===== blogリポジトリ（= ソース）をpush =====
if (-not (git diff --quiet)) {
  git add -A
  git commit -m "update: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
  git push origin main
}

# ===== GitHub Pages用リポジトリにpublicをコピーしてpush =====
cd ../hibisaboru.github.io
Copy-Item ../blog/public/* -Destination . -Recurse -Force

git add -A
git commit -m "deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin main

# ===== 作業リポジトリに戻る =====
cd ../blog