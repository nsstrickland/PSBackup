function Add-BackupItem {
    param (
        [parameter (Mandatory=$true, Position = 0)]
        [string[]]$FilePath,
        [parameter (Position = 1)]
        [string]$BackupRepo=$script:BackupRepository
    )
    if ($global:_backup_session_end) {
        Write-Output "Backup Session $($global:_backup_otd) was already completed at $global:_backup_session_end."
        return
    } else {
        Set-BackupPath $BackupRepo
        $backupList = @()
        if (-not $global:_backup_otd) {
            New-BackupSession -Force
        }
        foreach ($fileItem in $FilePath) {
            if (Test-Path $fileItem -ErrorAction SilentlyContinue) {
                $item = $null
                Get-Item $fileItem | foreach {
                    $backupList += [PSCustomObject] @{
                        Name=$PSItem.Name
                        FullName=$PSItem.FullName;
                        BackupRepo=$BackupRepo
                        BackupPath="$backupRepo\$($PSItem.Name).$($global:_backup_otd)"
                        OTD=[string]$global:_backup_otd
                        Timecode=$(get-date -Format 'MMddyyhhmmss')
                    }
                }
            }
        }
        $global:_backup_items+=$backupList
        return $backupList
    }
}