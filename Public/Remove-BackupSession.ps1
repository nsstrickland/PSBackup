function Remove-BackupSession {
    param (
        [switch]$Force
    )
    $run=0
    if ($global:_backup_otd) {
        Write-Verbose -Message "Session $($global:_backup_otd) active."
        if ($Force) {$run=1} else {
            $run = Show-Prompt -Title "Close session $($global:_backup_otd)?" -Message "Are you sure you want to close this session?" -Default 0
        }
    } else {
        $run=1
    }
    if ($run) {
        [string]$global:_backup_otd=$null
        $global:_backup_session_start=$null
        $global:_backup_session_end=$null
        $global:_backup_items=$null
        $global:_backup_session_sub=$null
    }
}