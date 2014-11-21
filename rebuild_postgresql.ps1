 $computer = "ska-w000467"
 $geo_path = "E:\Geocomponent"
 write-Host $computer.computer -ForegroundColor Gray
 
if (Test-Connection -ComputerName $computer -Count 2 -Quiet)  {
    write-host $computer connected 
    copy-item -recurse -force -verbose "D:\Powershell\Postgres_Script_DB\rebuild-geo" -Destination \\$computer\e$
    write-host $computer "files are copied"
    }
 
 invoke-command -computername $computer -ScriptBlock { 
                Set-ExecutionPolicy unrestricted
                write-host "stopping services"
                get-service -name GeoService | stop-service -force -verbose -ErrorAction SilentlyContinue
                get-service -name Postgresql* | stop-service -force -verbose -ErrorAction SilentlyContinue
                Stop-Process -Name "java*" -Force -verbose -ErrorAction SilentlyContinue
                Stop-Process -Name "WinRun4J*" -Force -verbose -ErrorAction SilentlyContinue
                Stop-Process -Name "geo*" -Force -verbose -ErrorAction SilentlyContinue
                Stop-Process -Name "postgres*" -Force
                
                if ( test-path "E:\Geocomponent\PostgreSQL" ) { 
                    write-host "removing postgresql"
                    remove-item -force -recurse -ErrorAction SilentlyContinue E:\Geocomponent\PostgreSQL 
                    }
                remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue E:\Geocomponent\log\*.*
                     
                if ( test-path E:\Geocomponent02 ) { 
                     remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue E:\Geocomponent02
                    }
                }
    
write-host "Do the Database magic"      
psexec.exe \\ska-w000467 -u postgres -p P0stgres cmd /c "C:\Program Files (x86)\PostgreSQL\9.1\bin\initdb"  --encoding=utf-8 --lc-collate=Dutch_Netherlands.1252  -D  "E:\Geocomponent02\PostgreSQL\9.1\data\" 
           
invoke-command -computername $computer -scriptblock {
                copy-item -recurse -force -ErrorAction SilentlyContinue "E:\Geocomponent02\PostgreSQL" -destination "E:\Geocomponent" 
                get-service -name "postgresql-9.1" | start-service -verbose
                cmd /c "E:\rebuild-geo\rebuild-geo.cmd"
                get-service -name "geoservice" | start-service -verbose
                Remove-Item -Recurse -Force "E:\Geocomponent02" 
                }
