# docker build -f Dockerfile -t sandbox -t theaspect/sandbox .
# docker push theaspect/sandbox
# docker run --rm -it sandbox
# fb849f09398221adceddc5c930af6d691cf91df6e5450a4b8857ba539235ba78
# See https://hub.docker.com/r/nixos/nix
FROM debian:11.3-slim 

# Use bash instead of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Interpreters
RUN apt update && apt install --no-install-recommends --yes \
    python3.9 \
    ruby2.7 \
    nodejs \
    openjdk-11-jdk \
    curl \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# root/cling dependencies
RUN apt update && apt install --no-install-recommends --yes \
    dpkg-dev \
    cmake \
    g++ \
    gcc \
    binutils \
    libx11-dev \
    libxpm-dev \
    libxft-dev \
    libxext-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install ki
RUN curl -s https://get.sdkman.io | bash && \
    chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh" && \
    source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install kotlin && \
    sdk install ki

# Install root
RUN mkdir /root/.root/ && \
    curl https://root.cern/download/root_v6.24.02.Linux-ubuntu20-x86_64-gcc9.3.tar.gz | tar -xzv -C /opt/ && \
    source /opt/root/bin/thisroot.sh

# Install useful deps
RUN apt update && apt install --no-install-recommends --yes \
    mc \
    xxd \
    && rm -rf /var/lib/apt/lists/*

# Setup env for root
RUN echo '[[ -s "/opt/root/bin/thisroot.sh" ]] && source "/opt/root/bin/thisroot.sh"' >> /root/.bashrc