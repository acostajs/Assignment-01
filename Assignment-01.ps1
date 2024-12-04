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
        $FileName = (Read-Host -Prompt "How are you going to name your new file (Do not add .csv extension)?")
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
                        Import-CSV -Path $NewFullPath
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

    function DataCSV {
        $csvFileToReadPath = $FullPath
        $csvData = Import-csv -path $csvFileToReadPath
        $names = $csvData | ForEach-Object{$_.name}
        Write-Host $names

        $newpath = (read-host -Prompt "Input the new path")
        mkdir $newpath
        $newname = (read-host -Prompt "input the new name file")
        $newnamecsv = "$newname.csv"
        new-item -path $newpath -name $newnamecsv -itemtype "file"
        $newnewfullpath = join-path -Path $newpath -childpath $newnamecsv

        add-content -path $newnewfullpath -value $names
        Import-csv $newnewfullpath

        
    }




    Write-Host "Select a function to execute:"
    Write-Host "1 to Create a new CSV"
    Write-Host "2 to Read a CSV file"
    Write-Host "3 to Add content to a CSV file"
    Write-Host "4 for To retrieve information from a CSV file"
    Write-Host "5 for Exit"
    $Choice = (Read-Host -Prompt "Enter the number of your choice")
        if ([string]::IsNullOrWhiteSpace($Choice)) {
            Write-Host "A function has not been selected" -ForegroundColor Yellow
        }
        Switch ($Choice) {
            1 { CreateCSV }
            2 { ReadCSV }
            3 { AddContentCSV }
            4 { DataCSV }
            5 { ForExit }
            Default { Write-Host "Invalid choice. Please try again." -ForegroundColor Yellow }
        }  

    } while ($Global:Exit -ne "y")

Write-Host "Program exited. Goodbye!" -ForegroundColor Green -BackgroundColor Yellow  