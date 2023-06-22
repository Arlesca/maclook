param(
	# MAC Address:
	[String]$mac
)

# Store MAC registry in a string
# TODO: Takes a lot of memory. Find a more efficient way!
$macreg = (Invoke-WebRequest -Uri "https://gitlab.com/wireshark/wireshark/raw/master/manuf").Content

# Reformat provided MAC adress
# With regex
$mac = ($mac -replace '[.,:]')

for ($i = 2; $i -le 14; $i += 3) {
	$mac = $mac.Insert($i, ":")
}

# Write-Host $mac
$vndrid = $mac.SubString(0, 8)

# Iterate though each line of the registry string
foreach ($line in ($macreg -split "\n")) {
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
