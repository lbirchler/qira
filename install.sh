#!/bin/bash -e

# install system deps
if [ $(which apt) ]; then
  echo "installing deps for ubuntu"
  sudo apt -y install build-essential gcc-multilib g++-multilib lib32z1 git curl python3 python3-venv python3-dev python3-pip pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev libjpeg-dev
 
else
  echo "*** You'll need to install Ubuntu or get a working build env for qemu and python yourself ***"
fi

# build qemu
if [[ "$(uname)" == 'Linux' ]]; then
  if [ $(tracers/qemu/qira-i386 > /dev/null; echo $?) == 1 ]; then
    echo "QIRA QEMU appears to run okay"
  else
    echo "building QEMU"
    cd tracers
    ./qemu_build.sh
    cd ../
  fi
else
  echo "QEMU user only works on Linux."
  echo "While the rest of QIRA will run, you cannot run binaries."
  echo "This is due to QEMU user forwarding the syscalls to the kernel."
  echo "See other backends in qira/tracers, PIN may work on Windows and OS X"
fi

echo "building python venv"
python3 -m venv venv
source venv/bin/activate
pip3 install --upgrade pip
pip install --upgrade -r requirements.txt

echo "running tests"
./run_tests.sh

echo "making systemwide symlink"
sudo ln -sf $(pwd)/qira /usr/local/bin/qira

echo "***************************************"
echo "  Thanks for installing QIRA"
echo "  Check out README for more info"
echo "  Or just dive in with 'qira /bin/ls'"
echo "  And point Chrome to localhost:3002"
echo "    ~geohot"
