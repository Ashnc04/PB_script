# Définir la plage d'adresses IP
$startIP = "10.13.0.50"
$endIP = "10.13.0.75"

# Convertir les adresses IP en objets IPAddress
$startIPAddress = [System.Net.IPAddress]::Parse($startIP)
$endIPAddress = [System.Net.IPAddress]::Parse($endIP)

# Obtenir les octets de l'adresse IP de début et de fin
$startBytes = $startIPAddress.GetAddressBytes()
$endBytes = $endIPAddress.GetAddressBytes()

# Parcourir la plage d'adresses IP
for ($i = [System.BitConverter]::ToUInt32($startBytes, 0); $i -le [System.BitConverter]::ToUInt32($endBytes, 0); $i++) {
    # Convertir le nombre en adresse IP
    $ipBytes = [System.BitConverter]::GetBytes($i)
    $ip = [System.Net.IPAddress]::Parse([System.BitConverter]::ToString($ipBytes))

    # Tester la connectivité avec Test-Connection
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Output "$ip est en ligne"
    } else {
        Write-Output "$ip n'est pas en ligne"
    }
}
