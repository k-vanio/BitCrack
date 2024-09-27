#!/bin/bash

# Cloning keyhunt repository...
echo "Cloning keyhunt repository..."
git clone https://github.com/k-vanio/keyhunt && cd keyhunt && make && cp keyhunt /usr/local/bin/key && sudo chmod +x /usr/local/bin/key

cd ..

sudo rm -R keyhunt

# Cloning BitCrack repository...
echo "Cloning BitCrack repository..."
git clone https://github.com/k-vanio/BitCrack.git

# Enter the BitCrack directory
cd BitCrack

# Compile BitCrack with CUDA support
echo "Compile BitCrack with CUDA support"
make BUILD_CUDA=1

# Verify that the compilation was successful
if [ $? -ne 0 ]; then
    echo "Erro ao compilar o BitCrack."
    exit 1
fi

# Moving files
echo "Moving files from bin folder to /usr/local/bin..."
sudo mv bin/* /usr/local/bin/

# Check if the move was successful
if [ $? -ne 0 ]; then
    echo "Error moving files."
    exit 1
fi

sudo apt-get install htop -y

# BitCrack
echo "BitCrack installation and configuration completed successfully!"

cd ..

cp BitCrack/gpu gpu
cp BitCrack/cpu cpu
cp BitCrack/gsbs gsbs

sudo rm -R BitCrack

chmod +x gpu
chmod +x cpu
chmod +x gsbs

./gpu --name=67 --size=10000000000 --address=RTX-4090-default-gpu-1 > output-gpu-1.txt 2>&1 &
./gpu --name=67 --size=10000000000 --address=RTX-4090-default-gpu-2 > output-gpu-2.txt 2>&1 &
./gpu --name=67 --size=20000000000 --address=RTX-4090-default-gpu-3 > output-gpu-3.txt 2>&1 &
./gpu --name=67 --size=20000000000 --address=RTX-4090-default-gpu-4 > output-gpu-4.txt 2>&1 &
./gpu --name=67 --size=10000000000 --address=RTX-4090-default-gpu-5 > output-gpu-5.txt 2>&1 &

./cpu --name=67 --size=1000000000 --address=RTX-4090-default-cpu > output-cpu.txt 2>&1 &

./gsbs --name=135 --size=10000000000000000 -address=RTX-4090-default-gsbs > output-gsbs.txt 2>&1 &

echo "All commands running in parallel!"
