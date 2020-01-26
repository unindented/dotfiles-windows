function Set-VisualStudioVariables {
  pushd "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\Tools"
  cmd /c "VsDevCmd.bat&set" |
  foreach {
    if ($_ -match "=") {
      $v = $_.split("="); Set-Item -Force -Path "ENV:\$($v[0])" -Value "$($v[1])"
    }
  }
  popd
  Write-Host "Visual Studio 2017 variables set." -ForegroundColor Yellow
}

Set-VisualStudioVariables

Import-Module Get-ChildItemColor # https://github.com/joonro/Get-ChildItemColor

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColor -option AllScope
Set-Alias dir Get-ChildItemColor -option AllScope

Import-Module posh-sshell # https://github.com/dahlbyk/posh-sshell

Start-SshAgent -Quiet

Import-Module posh-git # https://github.com/dahlbyk/posh-git

$GitPromptSettings.DefaultPromptPrefix.Text = ""
$GitPromptSettings.DefaultPromptPath.Text = ""
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"
$GitPromptSettings.PathStatusSeparator = ""
$GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.DelimStatus.ForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.WindowTitle = ""

function Test-Administrator {
  $user = [Security.Principal.WindowsIdentity]::GetCurrent();
  (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
  $curTime = (Get-Date -Format "HH:mm:ss")
  $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
  if ($curPath.ToLower().StartsWith($Home.ToLower()))
  {
    $curPath = "~" + $curPath.SubString($Home.Length)
  }

  if (Test-Administrator) {
    Write-Host "[ELEVATED]" -NoNewline -ForegroundColor Red
  }
  Write-Host "[$curTime]" -NoNewline
  # Write-Host "[$env:USERNAME@$env:COMPUTERNAME]" -NoNewline -ForegroundColor Green
  Write-Host "[$curPath]" -NoNewline -ForegroundColor Blue

  & $GitPromptScriptBlock
}
