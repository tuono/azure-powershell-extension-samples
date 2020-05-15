# Install IIS and set the resulting page content to the computer name
# from: https://raw.githubusercontent.com/Azure/azure-docs-powershell-samples/master/application-gateway/iis/appgatewayurl.ps1
Add-WindowsFeature Web-Server
Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)
New-Item -ItemType directory -Path "C:\inetpub\wwwroot\images"
New-Item -ItemType directory -Path "C:\inetpub\wwwroot\video"
$imagevalue = "Images: " + $($env:computername)
Add-Content -Path "C:\inetpub\wwwroot\images\test.htm" -Value $imagevalue
$videovalue = "Video: " + $($env:computername)
Add-Content -Path "C:\inetpub\wwwroot\video\test.htm" -Value $videovalue

# Move IIS to port 8080 (idempotent)
Set-WebBinding -Name 'Default Web Site' -PropertyName Port -Value 8080

# Enable port 8080/tcp in Windows Firewall (idempotent)
$ruleName = 'Allow inbound TCP port 8080'
$rule = Get-NetFirewallRule -DisplayName $ruleName
if (-Not $rule) {
    New-NetFirewallRule -DisplayName $ruleName -Direction inbound -LocalPort 8080 -Protocol TCP -Action Allow
}
