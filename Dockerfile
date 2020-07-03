# Run a sshd service and create a user 'default' with ssh access and the ability to install software.

FROM ubuntu:18.04

LABEL maintainer="Blake Fleischer <blakeflei@gmail.com>"

# Install sshd
RUN apt-get update && \
    apt-get --yes install openssh-server rsync sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -vp /var/run/sshd
RUN mkdir -vp /usr/local/etc/sshd

COPY ./sshd_config /usr/local/etc/sshd/

RUN chmod -v 644 /usr/local/etc/sshd/*

# Create a default user and group, set password
RUN groupadd default -r -g 1000 && \
    useradd -u 1000 -o -m default -p saV9ejDMWuP92 -g default && \
    usermod -aG sudo \
      -s /bin/bash \
      default

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
