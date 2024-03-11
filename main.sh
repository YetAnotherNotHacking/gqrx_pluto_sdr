#!/bin/bash

# Install required packages
echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y libiio-utils libiio-cil libad9361-dev gqrx-sdr socat

# Install PlutoSDR drivers
echo "Installing PlutoSDR drivers..."
git clone https://github.com/analogdevicesinc/plutosdr-fw.git
cd plutosdr-fw
sudo ./install.sh
cd ..

# Create virtual COM port
echo "Creating virtual COM port..."
sudo socat -d -d pty,raw,echo=0 pty,raw,echo=0

# Connect PlutoSDR to computer
echo "Connect Adam Pluto receiver to your computer via USB."

# Wait for device to be recognized
echo "Waiting for Adam Pluto receiver to be recognized..."
sleep 5

# Find the PlutoSDR COM port
PLUTO_PORT=$(dmesg | grep "ttyUSB" | tail -n 1 | awk '{print $NF}')
echo "Found Adam Pluto receiver on port: $PLUTO_PORT"

# Configure GQRX
echo "Configuring GQRX..."
echo "[Device]" > ~/.config/gqrx/default.conf
echo "driver=plutosdr" >> ~/.config/gqrx/default.conf
echo "plugin_args=plutosdr=$PLUTO_PORT" >> ~/.config/gqrx/default.conf

# Start GQRX
echo "Starting GQRX..."
gqrx

echo "Setup complete. You can now use GQRX with your Adam Pluto receiver."
