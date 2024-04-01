function Get-BackupSessionHistory {
    $repoRegistry=$script:RepositoryRegistry
    $sessionList = @()
    Get-ChildItem $repoRegistry | foreach {
        $session=$null
        $session = Get-ItemProperty -Path "$($repoRegistry)\$($PSItem.PSChildName)"
        $sessionList+=[pscustomobject]@{
            'StartTime'=$session.StartTime
            'EndTime'=$session.EndTime
            'Subject'=$session.Subject
            'OTD'=$session.PSChildName
            'ItemCount'=(Get-ChildItem "$($repoRegistry)\$($PSItem.PSChildName)").count
        }
    }
    return $sessionList
}