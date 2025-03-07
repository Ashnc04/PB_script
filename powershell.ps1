
#scanner des ip
#de l'adresses 10.13.0.50 à 10.13.0.75
#ping
#si répond au ping => afficher actif
#sinon => afficher inactif

#collecter les donnés
#  |    |    |
#  /    /    /
#status de connexion
#hostname
#Mac adress
#nom OS
#version OS
#charge (proc,ram,swap,volumes)



#enregistrer dans un fichier (csv) horodaté et en centralisé de façon incrémentielle
#créer un fichier csv avec le chemin et le nom
#écrire une ligne pour chaque pc
#enregistrer


#fichier de log répertorier les étapes qui se passent en arrière plan quand le script se lance


# Définir la plage d'adresses IP à scanner
$startIP = "10.13.0.50"
$endIP = "10.13.0.75"

# Fonction pour convertir une adresse IP en entier
function Convert-IPToInt {
    param (
        [string]$IPAddress
    )
    $octets = $IPAddress.Split('.')
    return [int]([int]$octets[0] * 256 * 256 * 256 + [int]$octets[1] * 256 * 256 + [int]$octets[2] * 256 + [int]$octets[3])
}

# Fonction pour convertir un entier en adresse IP
function Convert-IntToIP {
    param (
        [int]$intIP
    )
    $octet1 = ($intIP -band 0xFF000000) -shr 24
    $octet2 = ($intIP -band 0x00FF0000) -shr 16
    $octet3 = ($intIP -band 0x0000FF00) -shr 8
    $octet4 = ($intIP -band 0x000000FF)
    return "$octet1.$octet2.$octet3.$octet4"
}

# Convertir les adresses IP de début et de fin en entiers
$startInt = Convert-IPToInt -IPAddress $startIP
$endInt = Convert-IPToInt -IPAddress $endIP

# Créer un fichier CSV horodaté
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$csvFile = "C:\ScanResults\ScanResults_$timestamp.csv"
$csvHeader = "IPAddress,Status,Hostname,MACAddress,Timestamp"

# Vérifier si le répertoire existe, sinon le créer
if (-Not (Test-Path -Path "C:\ScanResults")) {
    New-Item -Path "C:\ScanResults" -ItemType Directory
}

# Écrire l'en-tête dans le fichier CSV
$csvHeader | Out-File -FilePath $csvFile -Encoding utf8

# Scanner les adresses IP
for ($i = $startInt; $i -le $endInt; $i++) {
    $ip = Convert-IntToIP -intIP $i
    $pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet
    $status = if ($pingResult) { "Actif" } else { "Inactif" }

    if ($pingResult) {
        try {
            $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
        } catch {
            $hostname = "N/A"
            Write-Output "Erreur lors de la récupération du nom d'hôte pour $ip : $_"
        }

        try {
            $macAddress = (arp -a $ip | Select-String -Pattern "Physical Address" | Out-String).Trim()
        } catch {
            $macAddress = "N/A"
            Write-Output "Erreur lors de la récupération de l'adresse MAC pour $ip : $_"
        }
    } else {
        $hostname = "N/A"
        $macAddress = "N/A"
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $csvLine = "$ip,$status,$hostname,$macAddress,$timestamp"
    $csvLine | Out-File -FilePath $csvFile -Encoding utf8 -Append
    Write-Output "$ip est $status"
}

Write-Output "Scan terminé. Les résultats ont été enregistrés dans $csvFile"


























# Script PowerShell pour collecter des informations système

# Nom du fichier CSV de sortie
$outputFile = "inventaire.csv"

# Créer ou écraser le fichier CSV avec l'en-tête
"Adresse IP,Nom d'hôte,Statut de connexion,Charge du processeur,Utilisation de la RAM,Utilisation du SWAP,Espace disque utilisé,Espace disque disponible,Système d'exploitation,Version du système d'exploitation" | Out-File -FilePath $outputFile -Encoding utf8

# Collecte des informations
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet").IPAddress
$hostname = hostname
$uptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$cpuUsage = (Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 5 | Measure-Object -Property CounterValue -Average).Average
$ramUsage = (Get-CimInstance -ClassName Win32_OperatingSystem).TotalVisibleMemorySize / 1MB
$swapUsage = (Get-CimInstance -ClassName Win32_PageFileUsage).CurrentUsage / 1MB
$diskUsed = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3").DeviceID | ForEach-Object { (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$_'").VolumeName + ": " + (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$_'").Size }
$diskAvailable = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3").DeviceID | ForEach-Object { (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$_'").FreeSpace }
$osName = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
$osVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version

# Écriture des informations dans le fichier CSV
$info = "$ipAddress,$hostname,$uptime,$cpuUsage,$ramUsage,$swapUsage,$diskUsed,$diskAvailable,$osName,$osVersion"
$info | Out-File -FilePath $outputFile -Append -Encoding utf8

Write-Output "Inventaire terminé. Les résultats sont enregistrés dans $outputFile."
