#!/bin/bash

PACKAGES=(
	'system/framework/framework-res.apk'
	'system/app/SystemUI.apk'
)
THEMEPREFIX=CM9_
THEMENAME=ICS-with-GB-colours

if [ ! -d flashable/META-INF ]; then
	echo "Error: flashable directory not found"
	exit 1
fi

# Delete old packages
rm -rf flashable/system

# For each package...
for package in "${PACKAGES[@]}"; do
	# Create destination directory if it doesn't already exist
	directory="flashable/$(dirname "$package")"
	if [ ! -d "$directory" ]; then
		mkdir -p "$directory"
	fi

	# Copy each package into position
	packagename="$(basename "$package" .apk)"
	if ! cp "$packagename-rebuilt-aligned.apk" "$directory/$packagename.apk"; then
		echo "Error: $packagename has not been built"
		exit 1
	fi
done

# Create flashable zip
rm -f "${THEMEPREFIX}${THEMENAME}.zip"
cd flashable
zip -r ../"${THEMEPREFIX}${THEMENAME}.zip" .
