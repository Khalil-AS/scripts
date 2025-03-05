# Importer le module Active Directory
Import-Module ActiveDirectory

# Définir les UO
$OUs = @(
    "OU=Example,OU=For,DC=domain,DC=lan",
    "OU=Example2,OU=For,DC=domain,DC=lan",
)

# Parcourir chaque UO
foreach ($ou in $OUs) {
    # Récupérer les informations utilisateur pour l'UO actuelle
    $users = Get-ADUser -Filter * -SearchBase $ou -Property GivenName,Surname,EmailAddress,Title

    # Créer une liste pour stocker les informations
    $userList = @()

    # Parcourir chaque utilisateur et extraire les informations
    foreach ($user in $users) {
        # Filtrer pour s'assurer que tous les champs sont remplis
        if ($user.GivenName -and $user.Surname -and $user.EmailAddress -and $user.Title) {
            $userInfo = New-Object PSObject -Property @{
                "First Name" = $user.GivenName
                "Last Name" = $user.Surname
                "Email" = $user.EmailAddress
                "Position" = $user.Title
            }
            $userList += $userInfo
        }
    }

    # Déterminer le nom du fichier basé sur l'UO
    $ouName = $ou -replace "OU=([^,]+).*", '$1'
    $filePath = "C:\Users\admba\Desktop\user_information_$ouName.csv"

    # Exporter les informations dans un fichier CSV avec encodage Unicode et une virgule comme délimiteur
    $userList | Select-Object "First Name","Last Name","Email","Position" | Export-Csv -Path $filePath -NoTypeInformation -Delimiter "," -Encoding Unicode
}

Write-Output "Les données ont été exportées dans des fichiers CSV pour chaque UO."
