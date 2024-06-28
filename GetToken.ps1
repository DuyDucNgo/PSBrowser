function Get-Matcher {
    Write-Host "Reading regex from Json file"
    $regexFile = "BrowserReg.json"
    $dataFile = "UACH.txt"
    $result = @{}
    if ((Test-Path $regexFile) -and (Test-Path $dataFile)) {
        #Reading json file
        $hash = Get-Content -Raw $regexFile | ConvertFrom-Json
        $UAs = Get-Content $dataFile
        #Adding Browsername to $result hash with value is a list of Browser token.
        foreach ($node in $hash) {
            $name = $node.name
            $result.$name = [System.Collections.ArrayList]@()   
        }
        #loop throw CHUA list
        foreach ($ua in $UAs) {
            foreach ($node in $hash) {
                if ($ua -match $node.pattern) {
                    $name = $node.name
                    $token = $Matches[$node.group]
                    $result.$name.add($token)
                }
            }
        }
        Clear-Host
        Write-Host "- - - - - - Output - - - - - -"
        $keysSorted = $result.Keys | Sort-Object
        foreach ($key in $keysSorted) {
            if ($result[$key].Count -gt 0) {
                $uniqe = $result[$key] | Select-Object -Unique | Sort-Object
                Write-Host "Name:" $key
                foreach($val in $uniqe) {
                    Write-Host `t$val
                }
                Write-Host "- - - - - - - - - - - - - - -"
            }
        }
    } else {
        Write-Host "Please check the file location: BrowserReg.json and UACH.txt"
    }
}
Get-Matcher