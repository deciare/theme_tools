The bash scripts in this repository can be used simplify the process of extracting and packaging themes. These scripts assume that adb, apktool, unzip, zip, and zipalign are available from your $PATH.

Arch Linux users can acquire these tools by installing the following packages:
* android-sdk (AUR)
* android-sdk-platform-tools (AUR)
* android-apktool (AUR)
* unzip
* zip


extracttheme.sh
===============

Extracts a list of APK files given in the $PACKAGES array (edit the script to change it) from a given zip archive, and automatically installs the framework-res.apk file from that archive for use by apktool. Decompiles and unzips each extracted APK file. The unzipped versions of each APK are used by buildtheme.sh to retain the original APK's signature.

Usage
-----
    extracttheme.sh <zip>

Parameters
----------

__zip__ is the zip file from which to extract APKs. This is usually a flashable zip containing either a ROM or a theme.


buildtheme.sh
=============

Builds APK packages from directories given in the $PACKAGENAMES array (edit the script to change it). Retains the signature from the original APK by overwriting AndroidManifest.xml and META-INF/ with files from the original package.

Additional files from framework-res are overwritten to work around a problem where .9.png files for certain lockscreen graphics are recompiled incorrectly.

Usage
-----
    buildtheme.sh <directory> [ <directory> ... ]

Parameters
----------
__directory__ is the name of one or more directories, separated by spaces, from which to build APK pacakges. If at least one __directory__ is given on the command line, then they are used _instead of_ the list of directories given in the $PACAKGENAMES array.


buildflashable.sh
=================

Creates a flashable zip file by combining packages built by buildtheme.sh with an available flashable/ directory. Packages to include in the flashable zip are given by the $PACKAGES array (edit the file to change it).

A sample flashable/ directory is included in this repository.
