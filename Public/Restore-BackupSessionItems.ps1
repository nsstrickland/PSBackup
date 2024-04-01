using module ..\Private\variable.ps1
function Restore-BackupItems {
    param (
        [switch]$Remove
    )
    if (-not $global:_backup_session_end) {
        Write-Output "Backup Session $($global:_backup_otd) has not yet been completed. Nothing to restore."
        return
    } else {
        $session = Get-BackupSession
        $session.Items | ForEach-Object -Begin {
            Write-Output "Restoring items from backup session $($session.OTD)"
        } -Process {
            Write-Output "$($PSItem.Name).$($PSItem.OTD) -> $($PSItem.FullName)"
            Copy-Item -Path $PSItem.BackupPath -Destination $PSItem.FullName -Force
            if ( (Get-FileHash -Path $PSItem.FullName -Algorithm SHA256).Hash -eq (Get-FileHash -Path $PSItem.BackupPath -Algorithm SHA256).Hash ) {
                    Write-Output "Restore successful for file $($PSItem.Name)."
            } else {
                Write-Error "Error restoring file; hash did not match."
            }
        }
        if ($Remove) {
            Write-Output "Removing record of backup session."
            $session.Items | ForEach-Object -Process {
                Remove-Item -Path $PSItem.BackupPath -Force
            }
            Remove-Item -Path "$($script:RepositoryRegistry)\$($session.OTD)" -Force -Recurse
            Remove-BackupSession -Force
        }
    }
}