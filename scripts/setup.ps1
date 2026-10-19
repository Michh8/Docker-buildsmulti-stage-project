$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
if (Test-Path .env) { throw '.env ya existe; no se sobrescribe.' }
function New-Secret {
 $bytes = New-Object byte[] 32
 $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
 $rng.GetBytes($bytes)
 $rng.Dispose()
 return [Convert]::ToBase64String($bytes)
}
$contents = [IO.File]::ReadAllText((Join-Path $PWD '.env.example'))
$contents = $contents.Replace('replace-root-password', (New-Secret)).Replace('replace-app-password', (New-Secret))
$contents = $contents.Replace('APP_KEY=', ('APP_KEY=base64:' + (New-Secret)))
[IO.File]::WriteAllText((Join-Path $PWD '.env'), $contents)
Write-Host '.env creado con claves aleatorias.'
