function Start-BackupSession {
    param (
        [switch]$Remove=$false
    )
    if ($global:_backup_session_end) {
        Write-Output "Backup Session $($global:_backup_otd) was already completed at $global:_backup_session_end."
        return
    } else {
        $session = Get-BackupSession
        Write-Output "Commencing backup session $($session.OTD)."
        Write-Output "Session was started at $($session.'StartTime') and contains $($session.'ItemCount') files."
        $repoRegistry="$($script:RepositoryRegistry)\$($session.OTD)"
        Set-BackupPath -FullPath $repoRegistry

        $session.Items | foreach {
            Copy-Item -Path $PSItem.FullName -Destination $PSItem.BackupPath -Force
            if ( (Get-FileHash -Path $PSItem.FullName -Algorithm SHA256).Hash -eq (Get-FileHash -Path $PSItem.BackupPath -Algorithm SHA256).Hash ) {
                Write-Output "Backup successful for file $($PSItem.Name). Continuing to register."
                New-Item -Path "$($repoRegistry)\$($PSItem.Name)" -Force
                Set-ItemProperty -Path "$($repoRegistry)\$($PSItem.Name)" -Name FullName -Value $PSItem.FullName -Force
                Set-ItemProperty -Path "$($repoRegistry)\$($PSItem.Name)" -Name Name -Value $PSItem.Name -Force
                Set-ItemProperty -Path "$($repoRegistry)\$($PSItem.Name)" -Name BackupRepo -Value $PSItem.BackupRepo -Force
                Set-ItemProperty -Path "$($repoRegistry)\$($PSItem.Name)" -Name BackupPath -Value $PSItem.BackupPath -Force
                Set-ItemProperty -Path "$($repoRegistry)\$($PSItem.Name)" -Name OTD -Value $PSItem.OTD -Force
                Set-ItemProperty -Path "$($repoRegistry)\$($PSItem.Name)" -Name Timecode -Value $PSItem.Timecode -Force
                if ($Remove) { Remove-Item -Path $PSItem.FullName -Force}
            }
        }
        $proc=$(Get-Date)
        Set-ItemProperty -Path "$($repoRegistry)" -Name EndTime -Value $proc
        Set-ItemProperty -Path "$($repoRegistry)" -Name StartTime -Value $session.StartTime
        Set-ItemProperty -Path "$($repoRegistry)" -Name Subject -Value $session.Subject
        Write-Output "Backup session completed at $proc."
        Write-Output "Closing session $($session.OTD)."
        Remove-BackupSession -Force
    }
}