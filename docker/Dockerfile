FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install \
    git \
    tmux \
    build-essential \
    gcc-multilib \
    lib32z1 \
    git \
    curl \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    pkg-config \
    zlib1g-dev \
    libglib2.0-dev \
    libpixman-1-dev \
    libjpeg-dev \
    libssl-dev \
    libffi-dev \
    g++-multilib \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN git clone https://github.com/lbirchler/qira.git
WORKDIR /qira/tracers
RUN ./qemu_build.sh

# venv for qira
WORKDIR /qira
RUN bash -c "python3 -m venv venv && \
    source venv/bin/activate && \
    pip3 install pip --upgrade && \
    pip install --upgrade -r requirements.txt" 

# systemwide symlink
RUN ln -sf /qira/qira /usr/local/bin

# ** optional **
# install pwntools (outside of qira venv)
#   - if you want to cp/mount pwntools script and binary in container and run pwn.process(["qira", binary.path])
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade pwntools
