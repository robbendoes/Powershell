$target = Read-Host "Vul de inputmode in (ska)"

if (Test-Connection -ComputerName $target -Count 2 -Quiet)
    {
        Copy-Item -force -verbose "D:\Powershell\Postgres_Script_DB\serial-portreading.ps1"  "\\$target\d$"
        Write-Host $target "stopping geo" -ForegroundColor Gray               
        invoke-command -ComputerName $target -ScriptBlock {  
              Set-ExecutionPolicy unrestricted
              get-service -name geoservice | stop-service -verbose -Force -ErrorAction SilentlyContinue
              get-process winrun4j* | Stop-Process -force -verbose -ErrorAction SilentlyContinue
              get-process java* | Stop-Process -force -verbose -ErrorAction SilentlyContinue
              D:\serial-portreading.ps1   
              } 

    }
