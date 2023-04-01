# Use the official Ubuntu ARM64 image as the base
FROM arm64v8/ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV MAKEFLAGS="-j1"

# Install the necessary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    cmake \
    g++ \
    git \
    make \
    python3 \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/*

# Set up the working directory
WORKDIR /cling

# Clone the source code
RUN git clone http://root.cern.ch/git/llvm.git src/llvm && \
    cd src/llvm && \
    git checkout cling-patches && \
    cd tools && \
    git clone http://root.cern.ch/git/clang.git && \
    cd clang && \
    git checkout cling-patches && \
    cd .. && \
    git clone http://root.cern.ch/git/cling.git && \
    cd cling && \
    git checkout master && \
    cd ../../..

# Copy the build script into the image
COPY build.sh /cling/build.sh

# Make the build script executable
RUN chmod +x /cling/build.sh

# Run the build script
RUN /cling/build.sh

# Set the entrypoint to the cling binary
ENTRYPOINT ["/cling/inst/bin/cling"]
