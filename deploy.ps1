# ===== 設定 =====
$Hugo = "C:\Tools\hugo\hugo.exe"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BlogRepo = $ScriptDir
$PagesRepo = Join-Path (Split-Path -Parent $BlogRepo) "hibisaboru.github.io"

# ===== Hugoビルド =====
Set-Location $BlogRepo

& $Hugo
if ($LASTEXITCODE -ne 0) {
  Write-Error "Hugo build failed."
  exit 1
}

# ===== blogリポジトリ（= ソース）をpush =====
git diff --quiet
if ($LASTEXITCODE -ne 0) {
  git add -A
  git commit -m "update: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
  git push origin main
}

# ===== GitHub Pages用リポジトリにpublicをコピーしてpush =====
Set-Location $PagesRepo
Copy-Item "$BlogRepo\public\*" -Destination . -Recurse -Force

git add -A
git commit -m "deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin main

# ===== 作業リポジトリに戻る =====
Set-Location $BlogRepo