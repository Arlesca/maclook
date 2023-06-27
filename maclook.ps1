param(
	# MAC Address:
	[String]$mac
)

# Store MAC registry in a temporary file
$manuf = New-TemporaryFile
(Invoke-WebRequest -Uri "https://gitlab.com/wireshark/wireshark/raw/master/manuf").Content | Out-File $manuf

# Reformat provided MAC adress
$mac = ($mac -replace '[^a-zA-Z0-9]')

for ($i = 2; $i -le 14; $i += 3) {
	$mac = $mac.Insert($i, ":")
}

$vndrid = $mac.SubString(0, 8)

# Iterate though each line of the 'manuf' file
foreach ($line in Get-Content $manuf) {
	# If the line starts with '#' or is empty it is skipped
	if ( -not ($line.StartsWith("#")) -and ($line.length -ne 0)) {
		# Get vendor ID from the current line
		$compid = $line.SubString(0, 8)
		
		# Compare registry vendor ID
		# With the one provided
		if ($compid -eq $vndrid) {
			# Prints the line
			Write-Host $line
			break
		}
	}
}
