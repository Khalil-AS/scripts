# Demande à l'utilisateur de saisir les noms de groupes AD séparés par des virgules
$GroupNames = Read-Host "Veuillez entrer les noms de groupes AD separes par des virgules"

# Convertit la chaîne en tableau de noms de groupes
$GroupNamesArray = $GroupNames -split ',' | ForEach-Object { $_.Trim() }

# Pour chaque nom de groupe, obtenir les groupes desquels il est membre et les afficher
foreach ($GroupName in $GroupNamesArray) {
    # Récupère les groupes desquels le groupe est membre
    $ParentGroups = Get-ADGroup -Identity $GroupName -Properties MemberOf | Select-Object -ExpandProperty MemberOf

    # Si le groupe est membre d'autres groupes, affiche les noms des groupes parents
    if ($ParentGroups) {
        Write-Host "Le groupe '$GroupName' est membre des groupes suivants :"
        $ParentGroups | ForEach-Object {
            $ParentGroupName = ($_ -split ',')[0] -replace '^CN=', ''
            Write-Host "- $ParentGroupName"
        }
    } else {
        Write-Host "Le groupe '$GroupName' n'est membre d'aucun autre groupe."
    }
}
