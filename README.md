# raspberry-pi-multiroom-audio
A simple script for setting up a raspberry pi as a snapcast server or client.

## Basics
This is meant as a helper script to run on a Raspberry Pi using the base Raspbian image.

Assumptions
- Using Spotify as the audio source. This will install the [librespot](https://github.com/librespot-org/librespot) library from scratch (only required on the Server install).
- At least a Raspberry Pi 3.
- Clean install of Raspbian to start. If you've previously edited your config files the patches may cause **damage** to those files.
- [HifiBerry](https://www.hifiberry.com/) DAC will be used as the audio output.

## Installation
Two supported flags --server and --client

`./install --client` or `./install --server`

## Config files provided
1. [Config.patch](patches/config.patch) Update's proper config to /boot/config.conf. (Removes dtparam=audio=on and replaces it with dtoverlay=hifiberry-dacplus)
1. [Asound.patch](patches/asound.patch) Add's proper asound config for audio output through the HifiBerry DAC.
1. [Wpa.patch](patches/wpa.patch) Must edit this patch file to add your SSID and PSK password for the Raspberry Pi to auto boot to wifi.

## Support

- None. This is a convience script for me to use, feel free to do with it as you will, but I likely won't be doing much support in the future.

