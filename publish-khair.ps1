# Run from the extracted KHAIR_CREATIVE_RD_GITHUB_SOURCE folder in PowerShell:
#    powershell -ExecutionPolicy Bypass -File .\publish-khair.ps1
# Installs nothing automatically except npx can prompt for vercel CLI.
$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot
$repo = "omarkhair70-droid/khair-creative-rd"
foreach ($binary in @("git", "gh", "node", "npx")) {
  if (-not (Get-Command $binary -ErrorAction SilentlyContinue)) {
    throw "Missing '$binary'. Install Git, GitHub CLI and Node.js first, then run this script again."
  }
}
& gh auth status
if ($LASTEXITCODE -ne 0) {
  Write-Host "Sign in to GitHub once; a browser or device code may be required."
  & gh auth login
  if ($LASTEXITCODE -ne 0) { throw "GitHub sign-in did not complete." }
}
if (-not (Test-Path .git)) {
  & git init -b main
  if ($LASTEXITCODE -ne 0) { throw "git init failed" }
}
& git add --all
& git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
  & git commit -m "Launch Khair Creative R&D website"
  if ($LASTEXITCODE -ne 0) { throw "git commit failed: set git config user.name and user.email" }
}
& gh repo view $repo --json name --jq '.name' *> $null
if ($LASTEXITCODE -eq 0) {
  Write-Host "Repository already exists: $repo"
  $origin = (& git remote get-url origin 2>$null)
  if (-not $origin) { & git remote add origin "https://github.com/$repo.git" }
  & git push --set-upstream origin main
} else {
  & gh repo create $repo --public --source . --remote origin --push
}
if ($LASTEXITCODE -ne 0) { throw "GitHub push failed; Vercel deployment was not started." }
Write-Host "GitHub source uploaded: https://github.com/$repo"
Write-Host "Next: Vercel login/deploy. If asked for framework choose Other; root directory '.'; build command blank."
& npx --yes vercel@latest --prod
if ($LASTEXITCODE -ne 0) { throw "Vercel deployment did not finish. Source is still safe on GitHub." }
Write-Host "Check the Vercel deployment URL above."
