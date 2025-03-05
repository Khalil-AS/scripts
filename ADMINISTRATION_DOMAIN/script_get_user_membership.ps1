# Demande à l'utilisateur de saisir les noms d'utilisateurs AD séparés par des virgules
$Usernames = Read-Host "Veuillez entrer les noms d'utilisateurs AD separes par des virgules"

# Convertit la chaîne en tableau de noms d'utilisateurs
$UsernamesArray = $Usernames -split ',' | ForEach-Object { $_.Trim() }

# Pour chaque nom d'utilisateur, obtenir les groupes auxquels il appartient et les afficher
foreach ($Username in $UsernamesArray) {
    Write-Host "L'utilisateur $Username est membre des groupes suivants :"
    
    # Obtient les groupes auxquels appartient l'utilisateur et extrait uniquement les noms des groupes
    $UserGroups = Get-ADUser -Identity $Username -Properties MemberOf | Select-Object -ExpandProperty MemberOf | ForEach-Object {
        ($_ -split ',')[0] -replace '^CN=', ''
    } | Sort-Object -Unique

    # Affiche les groupes auxquels l'utilisateur appartient
    $UserGroups | Format-Table -AutoSize
}
