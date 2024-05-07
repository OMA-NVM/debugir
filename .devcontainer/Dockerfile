# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.241.1/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

SHELL ["/bin/bash", "-c"]

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
        && apt-get -y install --no-install-recommends --fix-missing \
        gcc gdb cmake make ninja-build libboost-all-dev git \
        htop wget fish zsh lld time parallel \
        icecc icecream-sundae libcolamd2 \
        build-essential doxygen libzstd-dev clang

# Set environment variables
ENV PATH=$PATH:/workspaces/debugir/build/

RUN echo "set completion-ignore-case on" >> /etc/inputrc

#Seting up icecc (icecream) distributed compiler.
#IceCream uses Ports: TCP: 10245 8765 8766 and for UDP 8765
EXPOSE 10245 8766 8765/TCP 8765/UDP
