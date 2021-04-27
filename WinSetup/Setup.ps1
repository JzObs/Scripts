Read-Host -Prompt "Press any button to start running $PSCommandPath"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    exit
}

Write-Host "Disable standby when using AC power" -ForegroundColor Yellow
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0
Write-Host "------------------------------------" -ForegroundColor Green

if (![bool](Get-Command choco -ErrorAction SilentlyContinue))
{
    Write-Host "Installing Chocolatey" -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "------------------------------------" -ForegroundColor Green
}

$Apps = @(
    "git",
    "make",
    "cmake",
    "7zip",
    "mingw"
)

foreach ($App in $Apps)
{
    Write-Host "Installing " $App -ForegroundColor Yellow
    choco install $App -y
    Write-Host "------------------------------------" -ForegroundColor Green
}

Read-Host -Prompt "Setup is finished. Press any button to exit"
exit
