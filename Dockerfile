# Use the official Ubuntu ARM64 image as the base
FROM arm64v8/ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

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

# Copy the build script into the image
COPY build.sh /cling/build.sh

# Make the build script executable
RUN chmod +x /cling/build.sh

# Run the build script
RUN /cling/build.sh

# Set the entrypoint to the cling binary
ENTRYPOINT ["/cling/inst/bin/cling"]
