function Get-BackupSession {
    param (
        [switch]$ItemsOnly
    )
    if ( -not $global:_backup_otd) {
        Write-Output -InputObject "No backup session active."
    } else {
        if ($ItemsOnly) {
            return $global:_backup_items
        } else {
            $i = @{
                'StartTime'=$global:_backup_session_start;
                'Subject'=$global:_backup_session_sub;
                'ItemCount'=$global:_backup_items.count;
                'Items'=$global:_backup_items;
                'OTD'=$global:_backup_otd;
            }
            if ($global:_backup_session_end) {
                $i+=@{'EndTime'=$global:_backup_session_end}
            }
            return [pscustomobject]$i
        }
    }
}