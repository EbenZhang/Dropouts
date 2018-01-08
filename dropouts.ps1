function PingGoogleDns() {
    $Name = '8.8.8.8'
    $Timeout = 2000
    $Ping = New-Object System.Net.NetworkInformation.Ping
    try{
        $Response = $Ping.Send($Name, $Timeout)
        return $Response.Status
    } catch{
        return "Error"
    }
}
$disconnectedTime = $null
while ($true) {
    $failedCount = 0
    $result = PingGoogleDns
    while ($result.ToString() -ne 'Success') {
        $failedCount = $failedCount + 1
        if ($failedCount -gt 4) {
            $disconnectedTime = Get-Date
            $msg = $disconnectedTime.ToString() + ": Disconnected"
            Write-Output $msg >> dropout.log
            Write-Host $msg
            break;
        }
        Start-Sleep -Seconds 1
        $result = PingGoogleDns
    }
    if ($result.ToString() -eq "Success") {

        if ($disconnectedTime -ne $null) {
            $msg = $disconnectedTime.ToString() + ": Resumed"
            Write-Output $msg >> dropout.log
            Write-Host $msg
        }
        $disconnectedTime = $null
        Write-Host "Succeed"
    }
    Start-Sleep -Seconds 1
}

