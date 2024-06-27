function Get-Matcher {
    Write-Host "Reading regex from Json file"
    $regexFile = "BrowserReg.json"
    $dataFile = "UACH.txt"
    $result = @{}
    if (Test-Path $regexFile) {
        #Reading json file
        $hash = Get-Content -Raw $regexFile | ConvertFrom-Json
        $UAs = Get-Content $dataFile
        #Adding Browsername to $result
        foreach ($node in $hash) {
            $name = $node.name
            $result.$name = [System.Collections.ArrayList]@()   
        }
        #loop throw hashtable
        foreach ($ua in $UAs) {
            foreach ($node in $hash) {
                if ($ua -match $node.pattern) {
                    $name = $node.name
                    $token = $Matches[$node.group]
                    #$result.Add($name, $token)
                    $result.$name.add($token)
                }
            }
        }
        #$result
        Clear-Host
        Write-Host "Result:"        
        foreach ($key in $result.Keys) {
            if ($result[$key].Count -gt 0) {
                $uniqe = $result[$key] | Select-Object -Unique | Sort-Object
                Write-Host "- - - - - - - - - - - - - - -"
                Write-Host $key
                foreach($val in $uniqe) {
                    Write-Host `t$val
                }
            }
        }
    } else {
        Write-Host "Please check the file BrowserReg.json"
    }

}
Get-Matcher