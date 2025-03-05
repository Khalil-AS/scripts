#Set New Parameters
$CertificateThumbprint = "B55113E1BAE06D1BD9BEDC161EE8C2B4F644AE30"
$ScriptPath = "C:\Path2Script\ToSign.ps1"

#Get the Certificate from Cert Store
$CodeSignCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Thumbprint -eq $CertificateThumbprint}

#Sign the PS1 file
Set-AuthenticodeSignature -FilePath $ScriptPath -Certificate $CodeSignCert -HashAlgorithm "SHA256"