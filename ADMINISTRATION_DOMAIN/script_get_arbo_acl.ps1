# Définir le chemin de départ pour l'arborescence
$path = "D:\"

# Fonction pour obtenir les droits NTFS d'un répertoire
function Get-NtfsPermissions {
    param (
        [string]$folderPath
    )

    try {
        $acl = Get-Acl -Path $folderPath
        $acl.Access | ForEach-Object {
            [PSCustomObject]@{
                Path        = $folderPath
                Identity    = $_.IdentityReference
                AccessType  = $_.AccessControlType
                Rights      = $_.FileSystemRights
                Inheritance = $_.IsInherited
                Propagation = $_.PropagationFlags
            }
        }
    } catch {
        Write-Warning ("Failed to get ACL for {0}: {1}" -f $folderPath, $_)
    }
}

# Lister tous les répertoires et sous-répertoires à partir de la racine D:
$folders = Get-ChildItem -Path $path -Recurse -Directory

# Ajouter le répertoire de départ (racine D:) à la liste
$folders = $folders + (Get-Item -Path $path)

# Obtenir et afficher les droits NTFS pour chaque répertoire
$permissions = $folders | ForEach-Object {
    Get-NtfsPermissions -folderPath $_.FullName
}

# Afficher les permissions
$permissions | Format-Table -AutoSize