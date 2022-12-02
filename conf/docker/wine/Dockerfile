FROM ubuntu:18.04

# Install tools
RUN \
    apt-get update -y && \
    apt-get install -y --install-recommends \
        wget

# Install wine
## ref: https://wiki.winehq.org/Ubuntu
## 1. enable 32 bit architecture
RUN dpkg --add-architecture i386
## 2. Download and add the repository key
RUN \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
## 3. download the WineHQ sources file
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
## 4. update package information and install wine
RUN \
    apt-get update -y && \
    apt-get install -y --install-recommends \
        winehq-stable
