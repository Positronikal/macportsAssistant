#!/bin/bash
# macports_updater.sh
# Hoyt Harness, Positronikal, 2024
#
# A shell script for macOS to update an existing MacPorts installation,
# including ports.
#
# Copyright (C) 2024 Hoyt Harness, hoyt.harness@gmail.com, Positronikal
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

set -euo pipefail

echo "Updating MacPorts base system..."
port -v selfupdate

echo "Upgrading outdated ports..."
port upgrade outdated

echo "Cleaning up inactive ports..."
port uninstall inactive

echo "Removing unrequested leaf ports..."
port uninstall leaves

echo "MacPorts update completed successfully!"
exit 0
