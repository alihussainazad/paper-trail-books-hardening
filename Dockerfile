FROM ubuntu:latest

# Install OpenSSH server, sudo, and security tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    ufw \
    && rm -rf /var/lib/apt/lists/*

# Create sshd runtime directory safely if not already present
RUN mkdir -p /var/run/sshd

# Create non-root user 'alice' and set password
RUN useradd -m -s /bin/bash alice && \
    echo 'alice:alice' | chpasswd && \
    usermod -aG sudo alice

# Configure SSH for Port 2222 and hardening options
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D"]

