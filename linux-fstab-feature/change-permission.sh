#!/bin/bash
cd "$(dirname "$0")"

# sudo chown -R root:root snap
# sudo chown -R $USER:$USER opt.* userdata.*
# sudo chown root:root opt.podman-desktop/chrome-sandbox
# sudo chmod 4755 opt.podman-desktop/chrome-sandbox

 sudo chown -R $USER:$USER userdata.*
 sudo chmod 644 userdata.bash.*
 sudo chown root:root userdata.bash.*

 sudo chmod 644 profile bashrc bash_history etc.fstab etc.docker.daemon.json change-permission.sh
 sudo chown root:root profile bashrc bash_history etc.fstab etc.docker.daemon.json change-permission.sh

