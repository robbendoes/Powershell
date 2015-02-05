# get the remote comport information from port 0 - 7

﻿while ($i -le 7) 
 {
    $k = "4800","9600","38400"
    foreach ( $ak in $k ) 
    { 
        write-host testing Baudrate $ak
        write-host testing COM port $i
        $port = New-Object System.IO.Ports.SerialPort
        $port.PortName = "COM$i"
        $port.BaudRate = "$ak"
        $port.Parity = "None"
        $port.DataBits = 8
        $port.StopBits = 1
        $port.ReadTimeout = 300 # 3 seconds
        $port.DtrEnable = "true"

        $port.open() #opens serial connection
        Start-Sleep 1 # wait 2 seconds until Arduino is ready
        try
        {
            $timeout = new-timespan -Seconds 15
            $sw = [diagnostics.stopwatch]::StartNew()
            while ($sw.elapsed -lt $timeout){
                $myinput = $port.ReadLine()
                $myinput
                start-sleep -seconds 1
                }
            
        }

        catch [TimeoutException]
        {
        # Error handling code here
        }

        finally
        {
        # Any cleanup code goes here
        } 
        $port.Close() #closes serial connection
    }
 $i++
}
