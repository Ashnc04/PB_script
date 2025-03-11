# Définir la plage d'adresses IP
$startIP = "10.13.0.50"
$endIP = "10.13.0.75"

# Convertir les adresses IP en objets IPAddress et en entiers
function ConvertTo-DecimalIP($ip) {
    $bytes = ([System.Net.IPAddress]::Parse($ip)).GetAddressBytes()
    [Array]::Reverse($bytes) # Convertir en big-endian pour correspondre à UInt32
    return [System.BitConverter]::ToUInt32($bytes, 0)
}

function ConvertTo-IPString($decimal) {
    $bytes = [System.BitConverter]::GetBytes($decimal)
    [Array]::Reverse($bytes) # Revenir en little-endian
    return [System.Net.IPAddress]::new($bytes).ToString()
}

$startDecimal = ConvertTo-DecimalIP $startIP
$endDecimal = ConvertTo-DecimalIP $endIP

# Parcourir la plage d'adresses IP
for ($i = $startDecimal; $i -le $endDecimal; $i++) {
    $ip = ConvertTo-IPString $i

    # Tester la connectivité avec Test-Connection
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Output "$ip est en ligne"
    } else {
        Write-Output "$ip n'est pas en ligne"
    }
}
