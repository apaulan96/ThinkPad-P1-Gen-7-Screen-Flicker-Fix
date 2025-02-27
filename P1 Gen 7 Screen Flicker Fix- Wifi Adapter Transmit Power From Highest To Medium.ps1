# Define the correct registry path
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003"

# Check if the key exists before modifying
if (Test-Path $regPath) {
    # Set Transmit Power (IbssTxPower) to Medium (50)
    Set-ItemProperty -Path $regPath -Name "IbssTxPower" -Value "50"
    Write-Output "Transmit Power (IbssTxPower) set to Medium (50) at $regPath"
} else {
    Write-Output "Registry path not found: $regPath"
}

# Restart the Wi-Fi adapter using netsh
$wifiAdapterName = (Get-NetAdapter | Where-Object { $_.InterfaceDescription -match "Wi-Fi" }).Name
if ($wifiAdapterName) {
    Write-Output "Restarting Wi-Fi adapter: $wifiAdapterName"
    Start-Process -FilePath "netsh" -ArgumentList "interface set interface name=`"$wifiAdapterName`" admin=disable" -Wait -NoNewWindow
    Start-Process -FilePath "netsh" -ArgumentList "interface set interface name=`"$wifiAdapterName`" admin=enable" -Wait -NoNewWindow
    Write-Output "Wi-Fi adapter restarted successfully."
} else {
    Write-Output "Wi-Fi adapter not found or unable to retrieve adapter name."
}
