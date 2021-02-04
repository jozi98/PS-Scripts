<#
Example for name of file: Week of Jan 25 2021_CutOff

Psuedocode:
1. Create source and destination directory
2. Create archive directory/folder name
3. Get the date for the start of the week
4. Call on Peform-Operation
5. Create String for archiveDir
6. Make archive directory
7. Loop through files in rootDir
    7.1 Try to Move file(s) to archiveDir
    7.2 Else Copy Item
    7.3 Skip file
8.Copy archiveDir folder and all files within it to sftpDir

#> 

function Perform-Operation{
    param($startOfWeekObject)
    $archiveDir = $rootDir + "Week of " + $startOfWeekObject.ToString("MMM") + " " + $startOfWeekObject.ToString("dd") + " " + $startOfWeekObject.ToString("yyyy") +  "_CutOff"
    mkdir $archiveDir
    Get-ChildItem $rootDir -File | 
    foreach { 
        try {
            #Will not go to catch statement as 
            #it does not cause a terminating error
            #Move-Item $_.FullName $archiveDir (This is a non-terminaiting error)

            #Will go to catch statement as this is now a terminating error, if file being moved is open
            Move-Item $_.FullName $archiveDir -ErrorAction Stop
        }
        catch  {
            try{
                #Will go to catch statement as it is a terminating error, if file being copied is open
                Copy-Item $_.FullName $archiveDir
            }
            catch{
            }
        }
        
    } 
    Copy-Item -Recurse $archiveDir $sftpDir
}

$rootDir = "C:\Users\JMobarik\Jehanzeb Mobarik\ONE-SLB Pictures\"
$sftpDir = "C:\Users\JMobarik\Jehanzeb Mobarik\Screenshots"

$currentDate = (Get-Date) # Returns Date object

$startOfWeekObject = $currentDate.AddDays(-($currentDate.DayOfWeek.value__-1))

Perform-Operation $startOfWeekObject # Call on function