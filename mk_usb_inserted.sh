#!/bin/bash
##############################################################################
# 
# Description   : Checkmk plugin to check for inserted USB storage devices.
#
# Author        : Daniel Sol
# Git           : https://github.com/szolll
# Email         : daniel.sol@gmail.com
# Version       : 1.2
# License       : GNU General Public License v3.0
# Usage         : Add the plugin to the default Checkmk agent's plugin folder.
# Notes         : This script checks for USB storage devices and reports a
#                 critical status if any are found. References ISO/IEC 27001:2013 A.10.1.1.
#
# Checkmk Version: 2.2.0.cre
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
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
####################################################################################

# Function to check for USB storage devices
check_usb_storage() {
    # Check if lsblk is installed
    if ! command -v lsblk &> /dev/null; then
        echo "2 'USB Storage Check' - CRITICAL - lsblk command not found. Please install the util-linux package."
        exit 2
    fi

    # Get a list of USB storage devices
    usb_devices=$(lsblk -o NAME,TRAN | grep usb)

    if [ -n "$usb_devices" ]; then
        # Remove newlines and format the output correctly for Checkmk
        usb_devices=$(echo "$usb_devices" | tr '\n' ' ')
        echo "2 'USB Storage Check' - CRITICAL - USB storage devices detected: $usb_devices (ISO 27001 A.10.1.1)"
    else
        echo "0 'USB Storage Check' - OK - No USB storage devices detected (ISO 27001 A.10.1.1)"
    fi
}

# Run the USB storage check
check_usb_storage
