# ===== 設定 =====
$ErrorActionPreference = "Stop"

$Hugo = "hugo"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BlogRepo = $ScriptDir
$PagesRepo = Join-Path (Split-Path -Parent $BlogRepo) "hibisaboru.github.io"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

# ===== コマンド確認 =====
if (-not (Get-Command $Hugo -ErrorAction SilentlyContinue)) {
  Write-Error "Hugo が見つかりません。winget版 Hugo が PATH に通っているか確認してください。"
  exit 1
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "Git が見つかりません。"
  exit 1
}

# ===== リポジトリ存在確認 =====
if (-not (Test-Path $BlogRepo)) {
  Write-Error "Blogリポジトリが見つかりません: $BlogRepo"
  exit 1
}

if (-not (Test-Path $PagesRepo)) {
  Write-Error "Pagesリポジトリが見つかりません: $PagesRepo"
  exit 1
}

# ===== Hugoビルド =====
Set-Location $BlogRepo

Write-Host "===== Hugo build ====="
& $Hugo

if ($LASTEXITCODE -ne 0) {
  Write-Error "Hugo build failed."
  exit 1
}

# ===== blogリポジトリ（= ソース）をpush =====
Write-Host "===== Push blog repo ====="

$BlogChanges = git status --porcelain

if ($BlogChanges) {
  git add -A
  git commit -m "update: $Timestamp"
  git push origin main
} else {
  Write-Host "Blog repo: no changes."
}

# ===== GitHub Pages用リポジトリにpublicをコピーしてpush =====
Write-Host "===== Copy public to Pages repo ====="

if (-not (Test-Path "$BlogRepo\public")) {
  Write-Error "publicフォルダが見つかりません。Hugo build が正常に出力していない可能性があります。"
  exit 1
}

Set-Location $PagesRepo

Copy-Item "$BlogRepo\public\*" -Destination . -Recurse -Force

Write-Host "===== Push Pages repo ====="

$PagesChanges = git status --porcelain

if ($PagesChanges) {
  git add -A
  git commit -m "deploy: $Timestamp"
  git push origin main
} else {
  Write-Host "Pages repo: no changes."
}

# ===== 作業リポジトリに戻る =====
Set-Location $BlogRepo

Write-Host "===== Deploy completed ====="