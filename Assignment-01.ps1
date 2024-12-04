# To save global variable for Exiting loop
$Global:Exit = "n"

# Function to exit the loop menu
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
    # Creates a new CSV file, in the path choosen, we can add content and read it.
    function CreateCSV {
        Write-Host "You have choosen to Create an CSV" -ForegroundColor Cyan

        # To choose the file directory
        $Path = (Read-Host -Prompt "Type the direction where you want to create a new folder") 
            if ([string]::IsNullOrWhiteSpace($Path)) {
                Write-Host "Invalid input: Exiting ..." -ForegroundColor Red
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
                            Write-Host "Invalid Input: Exiting ..."  -ForegroundColor Red
                            return
                        }
                        elseif (Test-Path -Path "$Path\$FolderName"){
                            Write-Host "The folder at your choosen direction already exist." -ForegroundColor Yellow
                        }
                        else {
                        mkdir "$Path\$FolderName"
                        Write-Host "Your new folder has been created in $path\$FolderName" -ForegroundColor Cyan
                        }
                }
            }   
        
        # To choose the files new name 
        $NewPath = "$Path\$FolderName"
        $FileName = (Read-Host -Prompt "Enter name for your new file (without extension)?")
        if ([string]::IsNullOrWhiteSpace($FileName)) {
            Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
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
                Write-Host "Your new file has been created at $FullPath" -ForegroundColor Cyan
            }
        Write-Host "Add some content to your new CSV file (Use commas to separate data)" -ForegroundColor Cyan
        $Global:FullPath = $FullPath
        Add-Content -Path $FullPath
        
        # To read the content and to add more content
        do {
            $Read = (Read-Host -Prompt "Would you like to read what you just wrote? (y/n)")
                if ([string]::IsNullOrWhiteSpace($Read)) {
                    Write-Host "Invalid Input: Exiting ..." -ForegroundColor Yellow
                    return
                }   
                elseif($Read.ToLower() -eq "n") {
                    Write-Host "You chose not to read the file." -ForegroundColor Cyan
                }
                elseif($Read.ToLower() -eq "y") {
                    Write-Host "Here is the content you wrote:" -ForegroundColor Cyan
                    Import-CSV $FullPath
                }
                else {
                    Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Red
                }

            $WriteAgain = (Read-Host -Prompt "Would you like to add more content to $File? (y/n)")
                if ([string]::IsNullOrWhiteSpace($WriteAgain)) {
                    Write-Host "Invalid Input: Exiting ..." -ForegroundColor Yellow
                    return
                }   
                elseif($WriteAgain.ToLower() -eq "n") {
                    Write-Host "You choose not to add more content." -ForegroundColor Yellow
                }
                elseif($WriteAgain.ToLower() -eq "y") {
                    Write-Host "Add some content to your new CSV file" -ForegroundColor Cyan
                    Add-Content -Path $FullPath
                }
                else {
                    Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Yellow
                }

        } while ($Read.ToLower() -ne "n" -and $WriteAgain.ToLower() -ne "n")
        return $FullPath
    } 

    # To read the last created CSV or another CSV File
    function ReadCSV {
        Write-Host "You have choosen to read a CSV file" -ForegroundColor Cyan
        write-host "The Last CSV was previously created at :$FullPath" -ForegroundColor Yellow
        
        $PreviousChoice = (Read-Host -Prompt "Do you want to read the CSV previously created? (y/n)" )
        $UserChoice = $PreviousChoice.ToLower()
            if ([string]::IsNullOrWhiteSpace($UserChoice)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            }
            elseif($UserChoice -ne "n" -and $UserChoice -ne "y") {
                Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Red
                return
            }
            elseif ($UserChoice -eq "y") {
                Import-CSV -Path $FullPath
            } 
            else {
                $NewFilePath = (Read-Host "Choose a different directory: (Input the new path)")
                    if([string]::IsNullOrWhiteSpace($NewFilePath)) {
                        Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                        return
                    }
                    elseif (-Not (Test-Path -Path $NewFilePath)) {
                        Write-Host "The path '$NewFilePath' does not exist. Please enter a valid directory." -ForegroundColor Red
                        return
                    }
                    else{
                        ls $NewFilePath
                    }
                $ChooseFile = (Read-Host -Prompt "Choose your file")
                $NewFullPath = Join-Path -Path $NewFilePath -ChildPath $ChooseFile
                    if([string]::IsNullOrWhiteSpace($ChooseFile)) {
                        Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                        return
                    }
                    elseif (-Not (Test-Path -Path $NewFullPath)) {
                        Write-Host "The file '$ChooseFile' does not exist. Please enter a valid directory." -ForegroundColor Yellow
                        return
                    }
                    else{
                        Get-Content -Path $NewFullPath
                    }
                
            }   
    }
    # Add content to the last created CSV or another CSV file   
    function AddContentCSV {
        Write-Host "You have choosen to modify a CSV" -ForegroundColor Cyan
        write-host "The Last CSV was previously created at :$FullPath" -ForegroundColor Yellow
        
        $PreviousChoice = (Read-Host -Prompt "Do you want to modify the CSV previously created? (y/n)" )
        $UserChoice = $PreviousChoice.ToLower()
            if ([string]::IsNullOrWhiteSpace($UserChoice)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            }
            elseif($UserChoice -ne "n" -and $UserChoice -ne "y") {
                Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Red
                return
            }
            elseif ($UserChoice -eq "y") {
                Import-CSV -Path $FullPath
                Write-Host "Add some content to your new CSV file (Use commas to separate data)" -ForegroundColor Cyan
                Add-Content -Path $FullPath
                Import-CSV -Path $FullPath
            } 
            else {
                $AnotherChoice = (Read-Host -Prompt "Do you want to modify another CSV file? (y/n)")
                $UserChoice2 = $AnotherChoice.ToLower()
                    if([string]::IsNullOrWhiteSpace($AnotherChoice)) {
                        Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                        return
                    }
                    elseif ($UserChoice2 -ne "n" -and $UserChoice2 -ne "y") {
                        Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Red
                        return
                    }
                    elseif ($UserChoice2 -eq "n") {
                        Write-Host "You have decided to not modify the file" -ForegroundColor Cyan
                        return
                    }              
                    else {
                        $NewFilePath = (Read-Host "Input the directory path")
                            if([string]::IsNullOrWhiteSpace($NewFilePath)) {
                                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                                return
                            }
                            elseif (-Not (Test-Path -Path $NewFilePath)) {
                                Write-Host "The path '$NewFilePath' does not exist. Please enter a valid directory." -ForegroundColor Red
                                return
                            }
                            else{
                                ls $NewFilePath
                            }
                        $ChooseFile = (Read-Host -Prompt "Choose your file")
                        $NewFullPath = Join-Path -Path $NewFilePath -ChildPath $ChooseFile
                            if([string]::IsNullOrWhiteSpace($ChooseFile)) {
                                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                                return
                            }
                            elseif (-Not (Test-Path -Path $NewFullPath)) {
                                Write-Host "The file '$ChooseFile' does not exist. Please enter a valid directory." -ForegroundColor Yellow
                                return
                            }
                            else{
                                Add-Content -Path $NewFullPath
                                Write-Host "Here you can see the modifications you have made" -ForegroundColor Cyan
                                Import-CSV -Path $NewFullPath
                            }
                        
                        
                    }
            
            }
    } 

    # To transfer data to a new CSV file, and archive the older version if necessary
    function DataCSV {
        Write-Host "The last created CSV is : $FullPath"
        $PreviousChoice = (Read-Host -Prompt "Do you want to import data from the previously created CSV? (y/n)")
        $UserChoice = $PreviousChoice.ToLower()
    
        if ([string]::IsNullOrWhiteSpace($UserChoice)) {
            Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
            return
        } elseif ($UserChoice -ne "n" -and $UserChoice -ne "y") {
            Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Red
            return
        }
    
        # Choose a file if the user decides not to use the last created CSV
        if ($UserChoice -eq "n") {
            $NewPath = Read-Host "Enter the directory where the desired file is located"
            if ([string]::IsNullOrWhiteSpace($NewPath)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            }
            elseif (-Not (Test-Path -Path $NewPath)) {
                Write-Host "Invalid directory path. Exiting ..." -ForegroundColor Red
                return
            }
    
            # List files in the folder
            Write-Host "Files in the folder:" -ForegroundColor Cyan
            ls $NewPath
    
            $ChosenFile = Read-Host "Enter the name of the file you want to use (including extension)"
            $FullPath = Join-Path -Path $NewPath -ChildPath $ChosenFile
            if ([string]::IsNullOrWhiteSpace($ChosenFile)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            }
            elseif (-Not (Test-Path -Path $FullPath)) {
                Write-Host "The selected file does not exist. Exiting ..." -ForegroundColor Red
                return
            }
        }
    
        $CsvData = Import-Csv -Path $FullPath
        $Global:ExtractedData = $null  # Clear previous data
    
        function Column {
            $ColumnName = Read-Host "Input the name of the column"
            if ([string]::IsNullOrWhiteSpace($ColumnName)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            }
            $Global:ExtractedData = $CsvData | ForEach-Object { $_.$ColumnName }
            Write-Host "Selected Column Data:"
            $Global:ExtractedData | ForEach-Object { Write-Host $_ }
        }
    
        function Row {
            $RowIndex = Read-Host "Input the row number (zero-based index)"
            if (-not [int]::TryParse($RowIndex, [ref]$null)) {
                Write-Host "Invalid row number. Please enter a valid number." -ForegroundColor Yellow
                return
            }
            $Global:ExtractedData = $CsvData[$RowIndex]
            Write-Host "Selected Row Data:"
            $Global:ExtractedData
        }
    
        function Cell {
            $ColumnName = Read-Host "Input the name of the column"
            if ([string]::IsNullOrWhiteSpace($ColumnName)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            }
            $RowIndex = Read-Host "Input the row number (zero-based index)"
            if (-not [int]::TryParse($RowIndex, [ref]$null)) {
                Write-Host "Invalid row number. Please enter a valid number." -ForegroundColor Yellow
                return
            }
            $Global:ExtractedData = $CsvData[$RowIndex].$ColumnName
            Write-Host "Selected Cell Value:"
            Write-Host $Global:ExtractedData
        }
    
        # Display options and invoke functions based on user choice
        Write-Host "Choose the information you want to extract:" -ForegroundColor Cyan
        Write-Host "1: To Choose a Column" -ForegroundColor DarkBlue
        Write-Host "2: To Choose a Row" -ForegroundColor DarkBlue
        Write-Host "3: To Choose a specific Cell" -ForegroundColor DarkBlue
    
        $Choice = Read-Host "Enter the number of your choice"
        if ([string]::IsNullOrWhiteSpace($Choice)) {
            Write-Host "No choice made. Exiting ..." -ForegroundColor Yellow
            return
        }
    
        Switch ($Choice) {
            1 { Column }  # Call Column function
            2 { Row }     # Call Row function
            3 { Cell }    # Call Cell function
            Default { Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow }
        }
    
        # Save the extracted data to a new file
        if ($Global:ExtractedData) {
            $SaveChoice = Read-Host "Would you like to save this data to a new file? (y/n)"
            if ([string]::IsNullOrWhiteSpace($SaveChoice)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            }
            elseif ($SaveChoice.ToLower() -eq "y") {
                $SavePath = Read-Host "Enter the directory to save the new file"
                if ([string]::IsNullOrWhiteSpace($SavePath)) {
                    Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                    return
                }
                elseif (-Not (Test-Path -Path $SavePath)) {
                    Write-Host "Invalid directory path. Exiting ..." -ForegroundColor Red
                    return
                }
                $FileName = Read-Host "Enter the name of the new file (without extension)"
                if ([string]::IsNullOrWhiteSpace($FileName)) {
                    Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                    return
                }
                $FileNameWithExtension = "$FileName.csv"
                $FullSavePath = Join-Path -Path $SavePath -ChildPath $FileNameWithExtension
    
                # Handle existing files and archive
                if (Test-Path -Path $FullSavePath) {
                    $ArchivePath = Join-Path -Path $SavePath -ChildPath "Archive"
    
                    # Create Archive folder if not exists
                    if (-Not (Test-Path -Path $ArchivePath)) {
                        New-Item -Path $ArchivePath -ItemType Directory
                    }
    
                    # Move the existing file to Archive
                    $TimeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
                    $ArchivedFileName = "$FileName`_$TimeStamp.csv"
                    $ArchivedFilePath = Join-Path -Path $ArchivePath -ChildPath $ArchivedFileName
    
                    Move-Item -Path $FullSavePath -Destination $ArchivedFilePath
                    Write-Host "Existing file moved to archive: $ArchivedFilePath" -ForegroundColor Green
                }
    
                # Handle different data structures
                if ($Global:ExtractedData -is [array]) {
                    $Global:ExtractedData | Out-File -FilePath $FullSavePath -Encoding utf8
                } elseif ($Global:ExtractedData -is [hashtable] -or $Global:ExtractedData -is [pscustomobject]) {
                    $Global:ExtractedData | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $FullSavePath -Encoding utf8
                } else {
                    Out-File -FilePath $FullSavePath -InputObject $Global:ExtractedData -Encoding utf8
                }
    
                Write-Host "Data saved to $FullSavePath" -ForegroundColor Green
            }
        } else {
            Write-Host "No data was extracted to save." -ForegroundColor Yellow
        }
    }

    function RemoveCSV {
        if(Test-Path -Path $FullPath){
            Write-Host "The last created CSV is : $FullPath"
            $PreviousChoice = (Read-Host -Prompt "Do you want to remove the previously created CSV? (y/n)")
            $UserChoice = $PreviousChoice.ToLower()
            if ([string]::IsNullOrWhiteSpace($UserChoice)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            } 
            elseif ($UserChoice -ne "n" -and $UserChoice -ne "y") {
                Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Red
                return
            }
            elseif ($UserChoice -eq "y") {
                Remove-Item -Path $FullPath
            }
        }       
        $RemoveChoice = (Read-Host -Prompt "Do you want to remove a file? (y/n)")
        $RemoveDecision = $RemoveChoice.ToLower()
        if ([string]::IsNullOrWhiteSpace($RemoveDecision)) {
            Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
            return
        } 
        elseif ($RemoveDecision -ne "n" -and $RemoveDecision -ne "y") {
            Write-Host "Invalid input. Please input 'y' for yes or 'n' for no." -ForegroundColor Red
            return
        }
        elseif ($RemoveDecision -eq "n"){
            return
        }
        else {
            $RemovePath = (Read-Host -Prompt "Input the path where the file you want to remove is located")
            if ([string]::IsNullOrWhiteSpace($RemovePath)) {
                Write-Host "Invalid Input: Exiting ..." -ForegroundColor Red
                return
            } 
            elseif (-Not (Test-Path -Path $RemovePath)) {
                Write-Host "Invalid directory path. Exiting ..." -ForegroundColor Red
                return
            }
            else {
                ls $RemovePath
                $RemoveFile = (Read-Host -Prompt "Which file do you want to remove?")
                $RemoveFullPath = Join-Path -Path $RemovePath -ChildPath $RemoveFile
                Remove-Item -Path $RemoveFullPath
            }
        }
    }

    Write-Host "Select a function to execute:"
    Write-Host "1 to Create a new CSV"
    Write-Host "2 to Read a CSV file"
    Write-Host "3 to Add content to a CSV file"
    Write-Host "4 to retrieve information from a CSV file and added it to a new file"
    Write-Host "5 to remove a file"
    Write-Host "6 for Exit"
    $Choice = (Read-Host -Prompt "Enter the number of your choice")
        if ([string]::IsNullOrWhiteSpace($Choice)) {
            Write-Host "A function has not been selected" -ForegroundColor Yellow
        }
        Switch ($Choice) {
            1 { CreateCSV }
            2 { ReadCSV }
            3 { AddContentCSV }
            4 { DataCSV }
            5 { RemoveCSV }
            6 { ForExit }
            Default { Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow }
        }  

    } while ($Global:Exit -ne "y")

Write-Host "Program exited. Goodbye!" -ForegroundColor Green -BackgroundColor Yellow  