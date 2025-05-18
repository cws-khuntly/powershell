Set-Alias -Name telnet -Value Test-NetConnection

#
# git things
#
if (Test-Path alias:ga) { Remove-Alias -Name ga -Force; Set-Alias -Name ga -Value "git add"; }
if (Test-Path alias:gp) { Remove-Alias -Name gp -Force; Set-Alias -Name gp -Value "git push"; }
if (Test-Path alias:gs) { Remove-Alias -Name gs -Force; Set-Alias -Name gs -Value "git status"; }
if (Test-Path alias:gm) { Remove-Alias -Name gm -Force; Set-Alias -Name gm -Value "git commit -sm"; }
if (Test-Path alias:rgc) { Remove-Alias -Name rgc -Force; Set-Alias -Name rgc -Value Write-Commit-Message; }
if (Test-Path alias:gc) { Remove-Alias -Name gc -Force; Set-Alias -Name gc -Value "git checkout"; }
if (Test-Path alias:gr) { Remove-Alias -Name gr -Force; Set-Alias -Name gr -Value "git rm"; }
if (Test-Path alias:gpu) { Remove-Alias -Name gpu -Force; Set-Alias -Name gpu -Value "git pull"; }
