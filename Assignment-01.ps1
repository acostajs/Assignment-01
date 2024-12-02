$Global:Exit = "n"
function ForExit {
    $ExitChoice = (Read-Host -Prompt "Do you want to exit? (y/n)").ToLower()
    if ([string]::IsNullOrWhiteSpace($ExitChoice)) {
        Write-Host "No input provided. Please enter 'y' to exit or 'n' to continue." -ForegroundColor Yellow
    } elseif ($ExitChoice -eq "y" -or $ExitChoice -eq "n") {
        $Global:Exit = $ExitChoice
    } else {
        Write-Host "Invalid input. Please enter 'y' to exit or 'n' to continue." -ForegroundColor Yellow
    }
}

Do {




    } while ($Global:Exit -ne "y")

Write-Host "Program exited. Goodbye!" -ForegroundColor Green -BackgroundColor Yellow  