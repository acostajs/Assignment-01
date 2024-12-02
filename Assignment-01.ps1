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
    
    function CreateCSV {
        Write-Host "You have choosen to Create an CSV"
        $Path = (Read-Host -Prompt "Type the direction where you want to create a new folder")
            if ([string]::IsNullOrWhiteSpace($Path)) {
                Write-Host "You have not written anything, exiting ..."
            return
            }
            else {
                if (-Not (Test-Path -Path $Path)) {
                    Write-Host "The path '$Path' does not exist. Please enter a valid directory." -ForegroundColor Red
                    return
                } 
                else {
                    $FolderName = (Read-Host -Prompt "Type the name of your new folder")
                        if ([string]::IsNullOrWhiteSpace($FolderName)) {
                            Write-Host "You have not written anything, exiting ..."
                            exit
                        }
                        elseif (Test-Path -Path "$Path\$FolderName"){
                            Write-Host "The folder at your choosen direction already exist." -ForegroundColor Yellow
                        }
                        else {
                        mkdir "$Path\$FolderName"
                        Write-Host "Your new folder has been created in $path\$FolderName as you can see above"
                        }
                }
            }    
        $NewPath = "$Path\$FolderName"
        $FileName = (Read-Host -Prompt "How are you going to name your new file?")
        if ([string]::IsNullOrWhiteSpace($FileName)) {
            Write-Host "You have not written anything"
            return
        }
        $File = "$FileName.csv"
        $FullPath = Join-Path -Path $NewPath -ChildPath $File
        

            if(Test-Path -Path $FullPath) {
                Write-Host "The file $FullPath already exists." -ForegroundColor Yellow
                return
            }
            else {
                New-Item -Path $NewPath -Name $File -ItemType "File"
                Write-Host "Your new file has been created at $FullPath"
            }
        Write-Host "Add some content to your new CSV file"
        $Global:FullPath = $FullPath
        Add-Content -Path $FullPath
    
        do {
            $Read = (Read-Host -Prompt "Would you like to read what you just wrote? (y/n)")
                if ([string]::IsNullOrWhiteSpace($Read)) {
                    Write-Host "Please input a valid answer" -ForegroundColor Yellow
                    return
                }   
                elseif($Read.ToLower() -eq "n") {
                    Write-Host "You chose not to read the file."
                }
                elseif($Read.ToLower() -eq "y") {
                    Write-Host "Here is the content you wrote:"
                    Import-CSV $FullPath
                }
                else {
                    Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Yellow
                }

            $WriteAgain = (Read-Host -Prompt "Would you like to add more content to $File? (y/n)")
                if ([string]::IsNullOrWhiteSpace($WriteAgain)) {
                    Write-Host "Please input a valid answer" -ForegroundColor Yellow
                    return
                }   
                elseif($WriteAgain.ToLower() -eq "n") {
                    Write-Host "You chose not to add more content."
                }
                elseif($WriteAgain.ToLower() -eq "y") {
                    Write-Host "Add some content to your new CSV file"
                    Add-Content -Path $FullPath
                }
                else {
                    Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Yellow
                }

        } while ($Read.ToLower() -ne "n" -and $WriteAgain.ToLower() -ne "n")
        return $FullPath
    } 

    




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