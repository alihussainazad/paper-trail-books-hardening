FROM ubuntu:latest

# Install OpenSSH server, sudo, and security tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    ufw \
    iptables \
    && rm -rf /var/lib/apt/lists/*

# Create sshd runtime directory safely
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

# Copy entrypoint script to handle firewall initialization
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]


