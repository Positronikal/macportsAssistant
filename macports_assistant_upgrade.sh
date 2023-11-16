#!/bin/sh

# macports_assistant_upgrade.sh
# Hoyt Harness, 2023
#
# A shell script for macOS 13 Ventura and later to upgrade an existing
# MacPorts installation for a previous version of macOS.
#
# Copyright (C) 2023 Hoyt Harness, hoyt.harness@gmail.com, Positronikal
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Run as root!

# Variables
rtusr=$(logname 2>/dev/null || echo $SUDO_USER)
rtusrgp=$(groups $rtusr | cut -d' ' -f 1)
installdir=/Users/$rtusr/bin/MacPorts
xccli=/Library/Developer/CommandLineTools
updtr=macports_updater.sh

# Check for and change to MacPorts dir:
if [ ! -d $installdir ]; then
    echo "macportsAssistant is not installed."
    echo "Run macports_assistant_install.sh to install."
    read -p "Press any key to exit..."
    exit
else
    cd /Users/$rtusr/bin/MacPorts
PATH="/Users/$rtusr/bin/MacPorts${PATH:+:$PATH}"
    echo "Changed working directory to: /Users/$rtusr/bin/MacPorts"
fi

# Install the latest version of the Xcode command-line tools:
echo "Removing existing Xcode CLI tools..."
rm -rf /Library/Developer/CommandLineTools

echo "Installing the latest version of Xcode CLI tools..."
xcode-select --install
read -p "Press any key to resume after Xcode CLI tools installation completes."
xcodebuild -license
echo "Done."

# Reinstall MacPorts base system:
case $osvers in
    14*)
        echo "Installing the MacPorts base system for Sonoma..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-14-Sonoma.pkg
        sudo installer -pkg MacPorts-2.8.1-14-Sonoma.pkg -target /
        echo "Done."
        ;;
    13*)
        echo "Installing the MacPorts base system for Ventura..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-13-Ventura.pkg
        sudo installer -pkg MacPorts-2.8.1-13-Ventura.pkg -target /
        echo "Done."
        ;;
    12*)
        echo "Installing the MacPorts base system for Monterey..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-12-Monterey.pkg
        sudo installer -pkg MacPorts-2.8.1-12-Monterey.pkg -target /
        echo "Done."
        ;;
    11*)
        echo "Installing the MacPorts base system for Big Sur..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-11-BigSur.pkg
        sudo installer -pkg MacPorts-2.8.1-11-BigSur.pkg -target /
        echo "Done."
        ;;
    10.15*)
        echo "Installing the MacPorts base system for Catalina..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-10.15-Catalina.pkg
        sudo installer -pkg MacPorts-2.8.1-10.15-Catalina.pkg -target /
        echo "Done."
        ;;
    10.14*)
        echo "Installing the MacPorts base system for Mojave..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-10.14-Mojave.pkg
        sudo installer -pkg MacPorts-2.8.1-10.14-Mojave.pkg -target /
        echo "Done."
        ;;
    10.13*)
        echo "Installing the MacPorts base system for High Sierra..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-10.13-HighSierra.pkg
        sudo installer -pkg MacPorts-2.8.1-10.13-HighSierra.pkg -target /
        echo "Done."
        ;;
    10.12*)
        echo "Installing the MacPorts base system for Sierra..."
        curl --location --remote-name https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1-10.12-Sierra.pkg
        sudo installer -pkg MacPorts-2.8.1-10.12-Sierra.pkg -target /
        echo "Done."
        ;;
    *)
        echo "This version of macOS is not supported... exiting."
        read -p "Press any key to exit..."
        exit
        ;;

# Uninstall your old ports:
echo "Uninstalling your old ports..."
rm myports.txt requested.txt
port -qv installed > myports.txt
port echo requested | cut -d ' ' -f 1 | uniq > requested.txt
sudo port -f uninstall installed
sudo port reclaim
echo "Done."

# Install your new ports:
echo "Installing your new ports"
rm restore_ports.tcl
curl --location --remote-name https://github.com/macports/macports-contrib/raw/master/restore_ports/restore_ports.tcl
chmod +x restore_ports.tcl
xattr -d com.apple.quarantine restore_ports.tcl
sudo ./restore_ports.tcl myports.txt
sudo port unsetrequested installed
xargs sudo port setrequested < requested.txt
echo "Done."

Echo "Updating MacPorts update script..."
cd ..
if [ -f $updtr ]; then
    rm -rf $updtr
else
    touch $updtr
    chown $rtusr:$rtusrgp $updtr
    chmod +x $updtr
    echo "#! /bin/sh" > $updtr
    echo >> $updtr
    echo "# macports_updater.sh" >> $updtr
    echo "# Hoyt Harness, Positronikal, 2023" >> $updtr
    echo "#" >> $updtr
    echo "# A shell script for macOS to update an existing MacPorts installation," >> $updtr
    echo "# including ports." >> $updtr
    echo "#" >> $updtr
    echo "# Copyright (C) 2023 Hoyt Harness, hoyt.harness@gmail.com, Positronikal" >> $updtr
    echo "#" >> $updtr
    echo "# This program is free software: you can redistribute it and/or modify" >> $updtr
    echo "# it under the terms of the GNU General Public License as published by" >> $updtr
    echo "# the Free Software Foundation, either version 3 of the License, or" >> $updtr
    echo "# (at your option) any later version." >> $updtr
    echo "#" >> $updtr
    echo "# This program is distributed in the hope that it will be useful," >> $updtr
    echo "# but WITHOUT ANY WARRANTY; without even the implied warranty of" >> $updtr
    echo "# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" >> $updtr
    echo "# GNU General Public License for more details." >> $updtr
    echo "#" >> $updtr
    echo "# You should have received a copy of the GNU General Public License" >> $updtr
    echo "# along with this program.  If not, see <http://www.gnu.org/licenses/>." >> $updtr
    echo >> $updtr >> $updtr
    echo "sudo port -v selfupdate" >> $updtr
    echo "sudo port upgrade outdated" >> $updtr
    echo "sudo port uninstall inactive" >> $updtr
    echo "sudo port uninstall rleaves" >> $updtr
    echo >> $updtr
    echo "exit" >> $updtr
fi
    echo "New MacPorts update script created. Run macports_updater.sh as root from terminal."

echo "MacPorts upgrade complete."

read -p "Press any key to exit..."

exit
