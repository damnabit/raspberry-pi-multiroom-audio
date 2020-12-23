#!/bin/bash
set -e

apt_update () {
   sudo apt-get update
}

patch_config () {
   BOOT_PATCH=./patches/config.patch

   if test -f "$BOOT_PATCH"; then
      echo "Patching boot config"
      sudo patch /boot/config.txt < $BOOT_PATCH
   else
      echo "No boot patch file found"
      exit 1 
   fi

   ASOUND_PATCH=./patches/asound.patch

   if test -f "$ASOUND_PATCH"; then
      echo "Patching asound config"
      sudo patch /etc/asound.conf < $ASOUND_PATCH
   else
      echo "No asound patch file found"
      exit 1 
   fi
}

wpa_patch () {
   WPA_PATCH=./patches/wpa.patch

   if test -f "$WPA_PATCH"; then
      echo "Patching wpa_supplicant"
      sudo patch /etc/wpa_supplicant/wpa_supplicant.conf < $WPA_PATCH
   else
      echo "No wpa patch file found"
      exit 1 
   fi
}

install_librespot () {
   git clone https://github.com/librespot-org/librespot.git
   cd librespot
   cargo build --release --no-default-features --target="arm-unknown-linux-gnueabihf"
   sudo mv ./target/arm-unknown-linux-gnueabihf/release/librespot /usr/local/bin/librespot
   cd ..
}

install_snapcast_server () {
   set -x
   echo "Updating apt-repo first"
   apt_update
   
   echo "Download deb files and attempt install"
   curl -LO https://github.com/badaix/snapcast/releases/download/v0.22.0/snapserver_0.22.0-1_armhf.deb
   sudo dpkg -i snapserver_0.22.0-1_armhf.deb
   sudo apt-get -y -f install
   sudo dpkg -i snapserver_0.22.0-1_armhf.deb
   sudo apt-get install -y build-essential libasound2-dev cargo
   
   echo "Download and install librespot repo. NOTE: This will take a while"
   install_librespot

   echo "Patch files"
   patch_config
}

install_snapcast_client () {
   set -x
   echo "Updating apt-repo first"
   apt_update

   echo "Download and install snapclient"
   curl -OL https://github.com/badaix/snapcast/releases/download/v0.22.0/snapclient_0.22.0-1_armhf.deb
   sudo dpkg -i snapclient_0.22.0-1_armhf.deb
   sudo apt-get -y -f install
   sudo dpkg -i snapclient_0.22.0-1_armhf.deb

   echo "Patch files"
   patch_config
}


if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

case $1 in
   --server)
      echo "server"
      install_snapcast_server
   ;;

   --client)
      echo "client"
      install_snapcast_client
   ;;

   *)
      echo "Error parsing arguments"
   ;;
esac

