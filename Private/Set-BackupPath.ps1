function Set-BackupPath {
    param (
        [string]$FullPath
    )
    $conPath=''
    $FullPath.Split('\')|%{
        $conPath+="$_\"
        if (Test-Path $conPath -ErrorAction SilentlyContinue) {
            Write-Output "$conPath exists."
        } else {
            Write-Output "$conPath does not exist; creating."
            try {
                New-Item -ItemType Directory -Path $conPath
            }
            catch {
                Write-Output "Failed to create $conPath"
                Write-Output "$_"
            }
        }
    }
}