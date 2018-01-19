FROM ubuntu:latest

MAINTAINER Ivan E. Cao-Berg <icaoberg@andrew.cmu.edu>
LABEL Description="CellOrganizer."
LABEL Vendor="Murphy Lab in the Computational Biology Department at Carnegie Mellon University"
LABEL Web="http://murphylab.cbd.cmu.edu"
LABEL Version="2.7.0"

USER root
RUN echo "Installing Matlab MCR 2017b"
RUN apt-get -qq update && apt-get -qq install -y \
    unzip \
    xorg \
    wget \
    tree \
    curl && \
    mkdir /mcr-install && \
    mkdir /opt/mcr && \
    cd /mcr-install && \
    echo "Downloading Matlab MCR 2017" && \
    wget -nc --quiet http://ssd.mathworks.com/supportfiles/downloads/R2017b/deployment_files/R2017b/installers/glnxa64/MCR_R2017b_glnxa64_installer.zip && \
    cd /mcr-install && \
    echo "Unzipping container" && \
    unzip -q MCR_R2017b_glnxa64_installer.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    echo "Removing temporary files" && \
    rm -rvf mcr-install
    
# Configure environment variables for MCR
ENV LD_LIBRARY_PATH /opt/mcr/v93/runtime/glnxa64:/opt/mcr/v93/bin/glnxa64:/opt/mcr/v93/sys/os/glnxa64
ENV XAPPLRESDIR /opt/mcr/v93/X11/app-defaults

# Configure environment
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash
ENV USERNAME murphylab
ENV HOME /home/$USERNAME/
ENV UID 1000
RUN useradd -m -s /bin/bash -N -u $UID $USERNAME
RUN if [ ! -d /home/$USERNAME/ ]; then mkdir /home/$USERNAME/; fi
WORKDIR /home/$USERNAME/
USER $USERNAME

RUN echo "Downloading CellOrganizer v2.7.0" && cd ~/ && wget -nc --quiet http://www.cellorganizer.org/Downloads/v2.7/cellorganizer-v2.7.0-binaries.tgz && tar -xvf cellorganizer-v2.7.0-binaries.tgz
RUN find . -type f -name "mccExcludedFiles.log" -exec rm -fv {} \;
RUN find . -type f -name "*.m" -exec rm -fv {} \;
RUN find . -type f -name "requiredMCRProducts.txt" -exec rm -fv {} \;
RUN find . -type f -name "readme.txt" -exec rm -fv {} \;
RUN find . -type f -name "run*.sh" -exec rm -fv {} \;
RUN tree ./cellorganizer