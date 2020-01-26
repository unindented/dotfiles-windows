PowerShellGet\Install-Module Get-ChildItemColor -Scope CurrentUser -AllowClobber -Force
PowerShellGet\Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force
PowerShellGet\Install-Module posh-sshell -Scope CurrentUser -Force

New-Item -ItemType SymbolicLink -Path $env:HOME\.gitattributes -Target .\gitattributes
New-Item -ItemType SymbolicLink -Path $env:HOME\.gitconfig -Target .\gitconfig
New-Item -ItemType SymbolicLink -Path $env:HOME\.gitignore -Target .\gitignore

New-Item -ItemType SymbolicLink -Path $profile.CurrentUserAllHosts -Target .\powershell\profile.ps1

# VSCode doesn't support symlinking settings: https://github.com/Microsoft/vscode/issues/37591
# New-Item -ItemType SymbolicLink -Path $env:APPDATA\Code\User\settings.json -Target .\vscode\settings.json
Copy-Item -Destination $env:APPDATA\Code\User\settings.json -Path .\vscode\settings.json
New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json -Target .\terminal\profiles.json

# Map Caps Lock to Ctrl.
$layout = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"}
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$layout)
