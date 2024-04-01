function Show-Prompt {
    param (
        [string]$Title,
        [string]$Message,
        [int]$Default=1
    )
    return $Host.UI.PromptForChoice( 
    $Title,
    $Message,
    @( 
        [Management.Automation.Host.ChoiceDescription]::new("&No", "No,"),
        [Management.Automation.Host.ChoiceDescription]::new("&Yes", "Yes")
    ),
    $Default # default choice
    )
}