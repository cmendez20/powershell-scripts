$homePath = "C:\Users\chrsm\"
$testPath = "C:\Users\chrsm\Downloads"

Write-Host "The home path is: $homePath and the test path is $testPath"

Copy-Item -Path $homePath\test4.txt -Destination $testPath\ -PassThru
