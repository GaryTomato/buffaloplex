# Buffalo + Plex
A Gadgets Under Construction project
Visit http://www.tomatosoft.hu/gadgets/portfolio/buffalo-linkstation-plex/ for the project page.

This repository contains (almost) all files necessary to recreate the custom firmware of the Buffalo + Plex project.
In cases where file size was a limitation, a link is provided to download the additional files.
The build script also checks if the files are available and downloads them as necessary.

How to use it?

This bunch of scripts create a full custom firmware for the Buffalo Linkstation from scratch, provided that all the necessary files of the project are in place. Download or clone the files to an up-to-date linux machine (I used CentOS 7) and create your first full build by running buildnewrelease with the below supplied parameters. (For a quick start, jump to buildnewrelease and read that paragraph.)

Directory: firmwares

This directory contains third-party code, like the Buffalo Linkstation firmware or the transmission binary. These were usually downloaded from other parties and the scripts directory within firmwares contains the URLs where they were downloaded from. (The get-* scripts.)
The scripts directory also contains some more complex scripts that you can copy to the Linkstation and run to set up specific environments.
debugplex - add a few files to the chroot environment of Plex (/usr/local/plexroot) so debug is easier
deploy-flexget - it sets up the python2.7 environment to download and install flexget
setup-compiler - sets up a complete compiler environment on the Linkstation to build transmission from source
You might need to change a few things in your setup to make it work, best to run them line-by-line, the first time you're trying.

Directory: resources

This directory contains additional resources that are needed for the custom firmware, namely passwords for the firmware so it can be unzipped. The additions folder contains tar-gzipped changes to the firmware. These usually just get untared and dumped into the firmware source directory during build. These might contain new scripts, webpage changes or other files that the custom firmware use during run.

Files: 0-9, A-Z

The different files are changes to the firmware that are run during the build process. The first step is to unzip the firmware into the "src" directory (created on the fly) and each of the files in this directory apply changes to the source. Then at the end Z-compile will re-zip the firmware so it can be downloaded and executed.

0-vars

This file contains the variables used across all scripts. All scripts will run this to get to know the default. When a component is upgraded, in this file you have to update the version number. (For example PLEXBIN contains the version of Plex Media Server to use.)

1-createsrc

This script will clean up old src directories by renaming them to old-src and do a fresh one from the vanilla firmware. The vanilla firmware is too big for GitHub to store so if it doesn't exist (after cloning), it will try to download it and place it in the proper directory (firmwares). The same happens to the Plex Media Server binary.
At the end you should have a "src" directory with the uncompressed firmware.

2-hackupdater

This will apply a patch to LSUpdater.ini in the firmware installation files so the same version of the firmware can be upgraded and a "debug" menu is available on the updater.

3-dev

This is an optionally run script that will copy every file from the resources/additions/test folder. (For developement.) It also copies some of the scripts from firmwares/scripts so it's easier to set up a Python2.7 or compiler environment.

4-optware

This adds optware awareness to the firmware. If optware was installed before the firmware upgrade, it will keep the dependencies at boot after the upgrade. It also copies optware bootstrap files to /root/optware-bootstrap so if optware was not installed yet, you have an easy start.

5-addplexbinary

This installs the chroot environment and Plex binaries for the firmware. It also updates the web interface so Plex can be configured.

6-addwebinterface

This installs additional settings like the Advanced Power Management piece for storage and the binary for the _auto_load script for BitTorrent.

7- changeutorrentweb

This updates the BitTorrent web interface and also updates the admin interface with additional settings regarding _auto_load.

8-addtransmission

This adds the necessary files for transmission, together with the skins and the web interface update.

9-updatenasnavi

This updates NasNavi in the firmware to a newer version.

A-advancedpower

This adds the necessary files and web changes to the firmware for the network keep-alive functionality.

B-nfs

This enables the NFS web interface and copies the necessary files to make it work.

C-ssh

This copies the necessary config files to enable SSH on port 2222 and the web interface changes to manage it.

D-autoupdate

This reconfigures autoupdate to look for new firmwares in DropBox, instead of the Buffalo website.

E-shortcuts

This reconfigures the web interface to show 4 shortcuts to different areas of the website on the bottom of the left pane.

Z-compile

This script compresses the "src" folder and creates a new firmware.
It requires two command line parameters: a name for the new release and a subversion number. For example:
"./Z-compile Chris 3.59" will create a firmware with the version number "1.69-Chris" and the subversion number 3.59.

buildnewrelease

This script will run all previous scripts to create a custom firmware. It takes three parameters: a name for the new release, a subversion number and an optional parameter "dev" to add the dev package into the firmware.
"./buildnewrelease Chris 3.59 dev" will build a new firmware from scratch with the version number 1.69-Chris and subversion 3.59.

