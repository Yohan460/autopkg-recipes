#!/bin/bash

# Changing permissions of the company portal application as they come incorrect from Microsft and cannot be edited during the package creation process
chmod -R 755 /Applications/CompanyPortal.app

exit $?