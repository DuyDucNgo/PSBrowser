function Get-Matcher {
    param (
      [Parameter(Mandatory = $false)]
      [string] $RegexFile = "BrowserPatterns.json",
      [Parameter(Mandatory = $false)]
      [string] $DataFile = "UACHs.csv"
    )
  
    # Validate file paths
    if (-not (Test-Path $RegexFile -PathType Leaf)) {
      Write-Warning "Regex file '$RegexFile' not found."
      return
    }
  
    if (-not (Test-Path $DataFile -PathType Leaf)) {
      Write-Warning "Data file '$DataFile' not found."
      return
    }
  
    # Load data
    try {
      $hash = Get-Content $RegexFile -Raw | ConvertFrom-Json
      $UAs = Get-Content $DataFile
    } catch {
      Write-Error "Error reading files: $_"
      return
    }
  
    # Initialize results hash with empty lists
    $result = @{}
    foreach ($node in $hash) {
      $result[$node.name] = @()
    }
    
    # Loop through user agents and match against patterns
    foreach ($ua in $UAs) {
      foreach ($node in $hash) {
        if (($ua -match $node.pattern) -and ($ua -notmatch $node.negative)) {
          $result[$node.name] += $Matches[$node.group]
        }
      }
    }
    Write-Host "- - - - - - Output - - - - - -"
    # Output results
    $keysSorted = $result.Keys | Sort-Object
    foreach ($key in $keysSorted) {
      if ($result[$key].Count -gt 0) {
        Write-Host "Name:" $key
        $unique = $result[$key] | Sort-Object -Unique
        $unique | ForEach-Object { Write-Host "   $_" }
        Write-Host "- - - - - - - - - - - - - - -"
      }
    }
  }
  Get-Matcher