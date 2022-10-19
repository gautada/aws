# AWS

This container is a client for AWS.  It can be configured to hold the credentials for accessing AWS or prompt the individual user for such.  This is also temporary anchor point for AWS designs.

Features:
 - This is a python aws client and can be accessed via **k exec...**
 - interactive smart AWS shell interface: https://github.com/awslabs/aws-shell
 X Provides a standard set of credentials for access the AWS cli
 - Provides a web interface for json development and executiion
 - Stores json macros for reference/future use.
 - Provides an ansible interface for admin (maybe ansible has a standard AWS client???)
 - Pulls status information for local monitoring


docker build --build-arg ALPINE_VERSION=3.16.2 --file Containerfile --label revision="$(git rev-parse HEAD)" --label version="$(date +%Y.%m.%d)" --no-cache --tag aws:build .

docker run --interactive --tty --name aws-client --rm aws:build 

docker compose run $(/usr/bin/basename $(pwd)) 

/usr/bin/sudo /usr/sbin/sshd -e -E /var/log/bastion.log -f /etc/ssh/sshd_config

 /usr/bin/ssh-keygen -A -N '' -f /opt/bastion/
