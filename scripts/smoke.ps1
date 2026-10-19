$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSVersion.Major -ge 7) {
 $PSDefaultParameterValues['Invoke-WebRequest:NoProxy'] = $true
 $PSDefaultParameterValues['Invoke-RestMethod:NoProxy'] = $true
}
$api = 'http://127.0.0.1:8000/api'
$ready = $false
for ($attempt = 0; $attempt -lt 30; $attempt++) {
 try {
  $response = Invoke-WebRequest 'http://127.0.0.1:3000' -TimeoutSec 2
  if ($response.StatusCode -eq 200) { $ready = $true; break }
 } catch { Start-Sleep -Seconds 1 }
}
if (-not $ready) { throw 'Frontend no inicio a tiempo' }
$health = Invoke-RestMethod "$api/health"
if ($health.status -ne 'ok') { throw 'Healthcheck fallo' }
$task = Invoke-RestMethod "$api/tasks" -Method Post -ContentType 'application/json' -Body '{"title":"Prueba Docker multi-stage"}'
try {
 $updated = Invoke-RestMethod "$api/tasks/$($task.id)" -Method Patch -ContentType 'application/json' -Body '{"completed":true}'
 if (-not $updated.completed) { throw 'Actualizacion fallo' }
 $page = Invoke-WebRequest 'http://127.0.0.1:3000'
 if ($page.Content -notmatch 'Prueba Docker multi-stage') { throw 'Frontend no muestra datos de MySQL' }
 $invalid = $false
 try { Invoke-RestMethod "$api/tasks" -Method Post -ContentType 'application/json' -Headers @{Accept='application/json'} -Body '{"title":""}' }
 catch { if ([int]$_.Exception.Response.StatusCode -ne 422) { throw }; $invalid = $true }
 if (-not $invalid) { throw 'La API acepto una tarea vacia' }
 Write-Host 'OK: health, creacion, actualizacion, validacion y renderizado Next.js/MySQL.'
} finally { Invoke-RestMethod "$api/tasks/$($task.id)" -Method Delete }
