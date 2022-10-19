ARG ALPINE_VERSION=3.16.2
# ╭――――――――――――――――---------------------------------------------------------――╮
# │                                                                           │
# │ STAGE 1: configure-aws -- Pull and build the AWS client from              │
# │                                                                           │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM gautada/alpine:$ALPINE_VERSION as configure-aws

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL version="2022-10-18"
LABEL source="https://github.com/gautada/aws-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="Container that provides the AWS client."

# ╭――――――――――――――――――――╮
# │ ENVIRONMENT        │
# ╰――――――――――――――――――――╯
COPY awscli.sh /etc/profile.d/awscli.sh
RUN /bin/ln -s /opt/development/awscli.credentials /etc/container/configmap.d/awscli.credentials \
 && /bin/ln -s /opt/development/awscli.config /etc/container/configmap.d/awscli.config

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
COPY 10-ep-container.sh /etc/container/entrypoint.d/10-ep-container.sh

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache aws-cli aws-cli-completer aws-cli-doc build-base nodejs npm openssh-client openssh python3 py3-pip yarn

# ╭――――――――――――――――――――╮
# │ SUDO               │
# ╰――――――――――――――――――――╯
COPY wheel-sshd /etc/container/wheel.d/wheel-sshd
COPY wheel-ssh-keygen /etc/container/wheel.d/wheel-ssh-keygen

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
ARG USER=awscli
# VOLUME /opt/$USER
RUN /bin/mkdir -p /opt/$USER \
 && /usr/sbin/addgroup $USER \
 && /usr/sbin/adduser -D -s /bin/ash -G $USER $USER \
 && /usr/sbin/usermod -aG wheel $USER \
 && /bin/echo "$USER:$USER" | chpasswd
# && /bin/chown $USER:$USER -R /opt/$USER
USER $USER
WORKDIR /home/$USER

# ╭――――――――――――――――――――╮
# │ PORTS              │
# ╰――――――――――――――――――――╯
EXPOSE 8080

# ╭――――――――――――――――――――╮
# │ CONFIGURE          │
# ╰――――――――――――――――――――╯
RUN /bin/mkdir /home/$USER/.aws \
 && /bin/ln -s /etc/container/configmap.d/awscli.credentials /home/$USER/.aws/credentials \
 && /bin/ln -s /etc/container/configmap.d/awscli.config /home/$USER/.aws/config \
 && /usr/bin/pip3 install --upgrade pip \
 && /usr/bin/pip3 install --upgrade boto3 \
 && /usr/bin/pip3 install aws-shell \
 && /usr/bin/yarn global add wetty
 


# USER root
