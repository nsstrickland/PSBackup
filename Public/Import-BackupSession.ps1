function Import-BackupSession {
    param (
        [parameter ( Mandatory = $true )]
        [string]$OTD
    )
    $repoRegistry=$($script:RepositoryRegistry)
    if ((Test-Path -Path "$($repoRegistry)\$OTD" -ErrorAction SilentlyContinue)) {
        $backupItems=@()
        Get-ChildItem "$($repoRegistry)\$OTD" | Get-ItemProperty | foreach {
            $backupItems += [PSCustomObject] @{
                Name=$PSItem.Name
                FullName=$PSItem.FullName;
                BackupRepo=$PSItem.BackupRepo
                BackupPath=$PSItem.BackupPath
                OTD=$PSItem.OTD
                Timecode=$PSItem.Timecode
            }
        }
        $session = Get-ItemProperty -Path "$($repoRegistry)\$OTD"
        $global:_backup_otd=$session.PSChildName
        $global:_backup_session_start=$session.StartTime
        $global:_backup_session_end=$session.EndTime
        $global:_backup_items=[pscustomobject[]]$backupItems
        $global:_backup_session_sub=$session.Subject
        Get-BackupSession
    } else {
        Write-Output "Entered Session ID is not valid."
        return
    }
}