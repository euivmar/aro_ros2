# syntax=docker/dockerfile:1.6.0

# Base image from NVIDIA based on a minimal ubuntu22.04
FROM nvidia/cuda:12.3.0-runtime-ubuntu22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# Install language
RUN apt-get update && apt-get install -y \
    locales \
    && locale-gen es_ES.UTF-8 \
    && update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8 \
    && rm -rf /var/lib/apt/lists/*
ENV LANG es_ES.UTF-8

# Install timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get -y upgrade \
    && rm -rf /var/lib/apt/lists/*

# Install common programs
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    lsb-release \
    sudo \
    cmake \
    gdb \
    git \
    software-properties-common \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

##########################################
# Expose the nvidia driver to allow opengl 
# Dependencies for glvnd and X11.
##########################################
RUN apt-get update \
    && apt-get install -y -qq --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
ENV QT_X11_NO_MITSHM 1

# Add ros2_setup_scripts git repository and install ros2.
ADD --keep-git-dir=true https://github.com/euivmar/ros2_setup_scripts_ubuntu.git#main /root/ros2_setup_scripts_ubuntu/
WORKDIR /root/ros2_setup_scripts_ubuntu
RUN /root/ros2_setup_scripts_ubuntu/run.sh
RUN /root/ros2_setup_scripts_ubuntu/installTurtlebot3SIM

###################################################################
# WARNING
# Because the build process happens in a non-interactive context
# sourcing the setup.bash is neccesary for the colcon build process
####################################################################
RUN /bin/bash -c 'source /opt/ros/humble/setup.bash && /root/ros2_setup_scripts_ubuntu/installTurtlebot3SIM_WS.sh'

