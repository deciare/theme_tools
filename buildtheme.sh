#!/bin/sh

PACKAGENAMES=(
	'framework-res'
	'SystemUI'
)
DPI="hdpi"

# Build only packages specified on the command line, if any
if [ $# -gt 0 ]; then
	unset PACKAGENAMES
	for i in "$@"; do
		PACKAGENAMES=("${PACKAGENAMES[@]}" "$i")
	done
fi

# For each package...
for packagename in "${PACKAGENAMES[@]}"; do
	# Delete already-built files
	rm -rf "$packagename"-rebuilt*

	# Build package
	if ! apktool b "$packagename" "$packagename"-rebuilt.apk; then
		echo "Error building $packagename"
		exit 1
	fi

	# Extract built package for modification
	unzip "$packagename"-rebuilt.apk -d "$packagename"-rebuilt-extract
	# Retain original package's signature
	cp -af "$packagename"-extract/AndroidManifest.xml "$packagename"-extract/META-INF "$packagename"-rebuilt-extract/

	# Work around breakage with certain .9.png files from framework-res
	if [ "$packagename" = "framework-res" ]; then
		cp -f "$packagename"-extract/res/drawable-$DPI/jog*tab*9.png "$packagename"-rebuilt-extract/res/drawable-$DPI/
		cp -f "$packagename"-extract/res/drawable-land-$DPI/jog*tab*9.png "$packagename"-rebuilt-extract/res/drawable-land-$DPI/
	fi

	# Repack modified package
	cd "$packagename"-rebuilt-extract
	zip -r ../"$packagename"-rebuilt.zip .
	cd ..
	zipalign 4 "$packagename"-rebuilt.zip "$packagename"-rebuilt-aligned.apk
	rm -rf "$packagename"-rebuilt-extract "$packagename"-rebuilt.apk "$packagename"-rebuilt.zip
done
