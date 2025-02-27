🚀 Lenovo P1 Gen 7 Wi-Fi Fix: Transmit Power Adjustment
📌 Issue Overview
Lenovo P1 Gen 7 laptops may experience screen flickering issues due to an improperly set Wi-Fi Transmit Power level. This issue is commonly found in laptops using Intel Wi-Fi 6E AX211, Intel Wi-Fi 7 BE200, or similar adapters.

🛠️ Solution
This PowerShell script automatically adjusts the Transmit Power setting to Medium (50), resolving the screen flickering issue. The script dynamically detects the correct Wi-Fi adapter and applies the fix, ensuring it works for any P1 Gen 7 device.

⚡ How It Works
✅ Detects the correct Wi-Fi adapter registry path.
✅ Modifies Transmit Power (IbssTxPower) to 50 (Medium).
✅ Restarts the Wi-Fi adapter to apply the changes.
✅ Works on any P1 Gen 7 Wi-Fi adapter (Intel, Realtek, etc.).
✅ Can be deployed via PowerShell or PDQ Deploy.
📥 Download & Run the Script
Method 1: Run Manually (PowerShell)
Download the script:
Click Code → Download ZIP → Extract the folder.
Or clone via Git:
sh
Copy
Edit
git clone [https://github.com/YOUR-USERNAME/Lenovo-P1-Gen7-Wifi-Fix.git](https://github.com/apaulan96/ThinkPad-P1-Gen-7-Screen-Flicker-Fix/blob/main/P1%20Gen%207%20Screen%20Flicker%20Fix-%20Wifi%20Adapter%20Transmit%20Power%20From%20Highest%20To%20Medium.ps1)
Open PowerShell as Administrator.
Navigate to the script directory:
powershell
Copy
Edit
cd "C:\Path\To\Script"
Run the script:
powershell
Copy
Edit
.\Fix-Wifi-P1Gen7.ps1
Restart your laptop (if needed).
Method 2: Deploy via PDQ Deploy
Create a new package in PDQ Deploy.
Add a PowerShell step and paste the script.
Set "Run As" to Local System (under Options).
Deploy to all affected devices.
📜 Script
Here’s the full PowerShell script:

powershell
Copy
Edit
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
❓ FAQ
1️⃣ What if my device still flickers after running the script?
Make sure the Transmit Power setting is set to Medium in Device Manager → Network Adapter → Advanced.
Reboot your device and check if the change persists.
2️⃣ Will this work on other Lenovo models?
This script is designed for the P1 Gen 7. However, it may work on similar ThinkPad models using Intel Wi-Fi adapters.
3️⃣ Can I undo this change?
Yes! You can manually revert the setting in Device Manager → Network Adapter → Advanced by selecting a different Transmit Power level.
⭐ Contributing
Feel free to:

Report issues in the Issues tab.
Submit Pull Requests if you improve the script.
🏆 Credits
Big shoutout to ChatGPT and @apaulan96 for developing and testing this fix! 🚀

📢 Spread the Word!
If this helped, give it a ⭐ on GitHub! It helps others find the fix. 😊
