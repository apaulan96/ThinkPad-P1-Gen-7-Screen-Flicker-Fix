# Define the base registry path for network adapters
$baseRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"

# Find all network adapter registry subkeys
$adapters = Get-ChildItem -Path $baseRegPath -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match "^\d+$" }

# Loop through each adapter registry key and find the Wi-Fi adapter
foreach ($adapter in $adapters) {
    $adapterProperties = Get-ItemProperty -Path $adapter.PSPath -ErrorAction SilentlyContinue
    
    if ($adapterProperties -and $adapterProperties.DriverDesc -match "Wi-Fi|Wireless") {
        # Found the correct Wi-Fi adapter registry path
        $wifiRegPath = $adapter.PSPath

        # Set the Transmit Power (IbssTxPower) to Medium (50)
        Set-ItemProperty -Path $wifiRegPath -Name "IbssTxPower" -Value "50"
        Write-Output "Transmit Power (IbssTxPower) set to Medium (50) for adapter: $($adapterProperties.DriverDesc)"

        # Restart Wi-Fi adapter using netsh
        $wifiAdapterName = (Get-NetAdapter | Where-Object { $_.InterfaceDescription -match "Wi-Fi" }).Name
        if ($wifiAdapterName) {
            Write-Output "Restarting Wi-Fi adapter: $wifiAdapterName"
            Start-Process -FilePath "netsh" -ArgumentList "interface set interface name=`"$wifiAdapterName`" admin=disable" -Wait -NoNewWindow
            Start-Process -FilePath "netsh" -ArgumentList "interface set interface name=`"$wifiAdapterName`" admin=enable" -Wait -NoNewWindow
            Write-Output "Wi-Fi adapter restarted successfully."
        } else {
            Write-Output "Wi-Fi adapter not found or unable to retrieve adapter name."
        }

        break  # Exit loop once the correct adapter is found and modified
    }
}

Write-Output "Script completed successfully."
