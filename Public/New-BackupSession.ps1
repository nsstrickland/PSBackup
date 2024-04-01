function New-BackupSession {
    param (
        [switch]$Force,
        [string]$Subject
    )
    $run=0
    if ($global:_backup_otd) {
        Write-Verbose -Message "Session $($global:_backup_otd) already active."
        if ($Force) {$run=1} else {
            $run = Show-Prompt -Title "Backup session $($global:_backup_otd) is already active." -Message "Close current backup session?" -Default 0
        }
    } else {
        $run=1
    }
    if ($run) {
        Remove-BackupSession -Force
        [string]$global:_backup_otd=(New-Guid).Guid.Split('-')[4]
        $global:_backup_session_start=Get-Date
        $global:_backup_session_end=$null
        $global:_backup_items=@()
        if ($Subject) {
            $global:_backup_session_sub=$Subject
        } else {
            $global:_backup_session_sub='None'
        }
        Get-BackupSession
    }
}