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




    Write-Host "Select a function to execute:"
    Write-Host "1 for CreateCSV"
    Write-Host "2 for ModifyCSV"
    Write-Host "3 for ImportFromCSV"
    Write-Host "4 for Exit"
    $Choice = (Read-Host -Prompt "Enter the number of your choice")
        if ([string]::IsNullOrWhiteSpace($Choice)) {
            Write-Host "A function has not been selected" -ForegroundColor Yellow
        }
        Switch ($Choice) {
            1 { CreateCSV }
            2 { ModifyCSV }
            3 { ImportFromCSV }
            4 { ForExit }
            Default { Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow }
        }  

    } while ($Global:Exit -ne "y")

Write-Host "Program exited. Goodbye!" -ForegroundColor Green -BackgroundColor Yellow  