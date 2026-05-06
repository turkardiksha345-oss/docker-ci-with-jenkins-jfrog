FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    sudo \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create runner user
RUN useradd -m runner
WORKDIR /home/runner

# Download GitHub Actions Runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.334.0/actions-runner-linux-x64-2.334.0.tar.gz \
    && tar xzf actions-runner.tar.gz \
    && rm actions-runner.tar.gz

# Install runner dependencies
RUN ./bin/installdependencies.sh

# Copy entrypoint script
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER runner

ENTRYPOINT ["/start.sh"]