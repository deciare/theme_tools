#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <flashable_zip>"
	exit 1
fi

# Array of packages to extract from flashable zip
PACKAGES=(
	'system/framework/framework-res.apk'
	'system/app/SystemUI.apk'
)

# For each package...
for package in "${PACKAGES[@]}"; do
	# Remove old package and working directories
	packagename="$(basename "$package" .apk)"
	rm -rf "$packagename".apk "$packagename" "$packagename-extract"

	# Extract each package
	unzip -j "$1" "$package"
done

# Install framework-res (mandatory)
if [ ! -f "framework-res.apk" ]; then
	echo "Error: framework-res.apk not available"
	exit 1
fi
apktool if framework-res.apk

# For each package...
for package in "${PACKAGES[@]}"; do
	packagename="$(basename "$package" .apk)"
	
	# Extract without decompiling
	unzip "$packagename".apk -d "$packagename-extract"

	# Decompile
	apktool d "$packagename".apk
done
