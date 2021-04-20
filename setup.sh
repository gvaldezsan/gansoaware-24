# Install prerequisites
sudo apt install netbase git libc6 libssl-dev libstdc++6 lsb-release libhackrf-dev liblimesuite-dev build-essential net-tools pkg-config libncurses5-dev libbladerf-dev libfam0 lighttpd librtlsdr-dev libusb-1.0-0-dev tcl-dev chrpath debhelper tcl8.6-dev python3-dev python3-venv libz-dev dh-systemd libboost-system-dev libboost-program-options-dev libboost-regex-dev libboost-filesystem-dev tcl tclx8.4 tcllib tcl-tls itcl3 -y
sudo dpkg --add-architecture armhf
sudo apt install libc6:armhf python3:armhf -y
ldconfig
sudo apt update
sudo apt dist-upgrade

# Install patched TCL-TLS (Flightaware)
cd ~/
git clone http://github.com/flightaware/tcltls-rebuild.git
cd tcltls-rebuild
./prepare-build.sh buster
cd package-buster
sudo dpkg-buildpackage -b --no-sign
cd ../
sudo dpkg -i tcl-tls_1.7.16-1+fa1_arm64.deb

# Install PiAware
cd ~/
git clone https://github.com/flightaware/piaware_builder
cd piaware_builder
sudo ./sensible-build.sh buster
cd package-buster
sudo dpkg-buildpackage -b --no-sign
cd ../
sudo dpkg -i piaware_5.0_arm64.deb
sudo systemctl restart piaware

# Install Dump1090
cd ~/
mkdir dump1090
cd dump1090
git clone https://github.com/flightaware/dump1090 dump1090-fa
cd dump1090-fa
sudo dpkg-buildpackage -b --no-sign
cd ../
sudo dpkg -i dump1090-fa_5.0_arm64.deb
sudo systemctl restart dump1090-fa

# Install FR24
bash -c "$(wget -O - https://repo-feed.flightradar24.com/install_fr24_rpi.sh)"
systemctl restart fr24feed
systemctl enable fr24feed

# Install Radarbox
sudo bash -c "$(wget -O - http://apt.rb24.com/inst_rbfeeder.sh)"
sudo apt-get install mlat-client -y
sudo systemctl restart rbfeeder


# Install Piaware Web Interface
cd ~/
git clone https://github.com/flightaware/piaware-web
sudo ./prepare-build.sh buster
cd package-buster
sudo dpkg-buildpackage -b --no-sign
cd ../
sudo dpkg -i piaware-web_5.0_al
