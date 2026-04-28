# ===== 設定 =====
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BlogRepo = $ScriptDir
$PagesRepo = Join-Path (Split-Path -Parent $BlogRepo) "hibisaboru.github.io"

# ===== blogリポジトリを最新化 =====
Write-Host ""
Write-Host "=== Updating blog repository ===" -ForegroundColor Cyan
Set-Location $BlogRepo

$BlogStatus = git status --short

if ($BlogStatus.Length -gt 0) {
  Write-Host ""
  Write-Host "blogリポジトリに未コミットの変更があります。" -ForegroundColor Yellow
  Write-Host "先に内容を確認し、commitするか、変更を取り消してください。"
  Write-Host ""
  git status --short
  exit 1
}

git pull origin main
if ($LASTEXITCODE -ne 0) {
  Write-Error "blog repository pull failed."
  exit 1
}

# ===== GitHub Pages用リポジトリを最新化 =====
if (Test-Path $PagesRepo) {
  Write-Host ""
  Write-Host "=== Updating GitHub Pages repository ===" -ForegroundColor Cyan
  Set-Location $PagesRepo

  $PagesStatus = git status --short

  if ($PagesStatus.Length -gt 0) {
    Write-Host ""
    Write-Host "GitHub Pagesリポジトリに未コミットの変更があります。" -ForegroundColor Yellow
    Write-Host "先に内容を確認してください。"
    Write-Host ""
    git status --short
    exit 1
  }

  git pull origin main
  if ($LASTEXITCODE -ne 0) {
    Write-Error "GitHub Pages repository pull failed."
    exit 1
  }
}
else {
  Write-Host ""
  Write-Host "GitHub Pages用リポジトリが見つかりません。" -ForegroundColor Yellow
  Write-Host "想定パス: $PagesRepo"
  Write-Host "deploy.ps1を使う場合は、hibisaboru.github.io も clone してください。"
}

# ===== blogリポジトリに戻る =====
Set-Location $BlogRepo

Write-Host ""
Write-Host "同期完了しました。" -ForegroundColor Green