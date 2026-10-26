FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update system and install OpenSSH, UFW, and sudo
RUN apt-get update && apt-get install -y \
    openssh-server \
    ufw \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create SSH run directory safely
RUN mkdir -p /var/run/sshd

# 1. Disable root login and fix PAM for Docker containers
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config

# 2. Add non-root user 'alice' with sudo access
RUN useradd -m -s /bin/bash alice && echo 'alice:alicepass' | chpasswd && adduser alice sudo

# 3. Configure key-based auth for alice
RUN mkdir -p /home/alice/.ssh && \
    chmod 700 /home/alice/.ssh && \
    chown -R alice:alice /home/alice/.ssh

# 4. Allow port 22 and enable UFW via configuration safely
RUN ufw allow 22 && \
    sed -i 's/ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
