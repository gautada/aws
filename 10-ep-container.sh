#!/bin/ash
#
# This is the example downstream entrypoint, launching either a container process or launch a
# container service. If launching a container process use `return 1` to block any subsequent
# entrypoint scripts.  Otherwise `return 0` for any container services to continue calling
# huigher numbered entrypoint scripts.
#
# DOWNSTREAM CONTAINERS SHOULD OVERWRITE THIS SCRIPT
# echo "... [$0] ..."

echo "---------- [ AWS CLIENT CONTAINER(...) ] ----------"
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ] ; then
 /usr/bin/sudo /usr/bin/ssh-keygen -A -t rsa -N ''
fi
/usr/bin/sudo /usr/sbin/sshd
if [ ! -f /home/awscli/.ssh/id_rsa ] ; then
 /bin/mkdir /home/awscli/.ssh
 /bin/chmod 700 /home/awscli/.ssh
 /usr/bin/ssh-keygen -t rsa -N '' -f /home/awscli/.ssh/id_rsa
 /bin/cp /home/awscli/.ssh/id_rsa.pub /home/awscli/.ssh/authorized_keys
 /bin/chmod 600 /home/awscli/.ssh/authorized_keys
fi
if [ -z "$ENTRYPOINT_PARAMS" ] ; then
 /home/awscli/.yarn/bin/wetty --port 8080 --ssh-host localhost --ssh-user awscli --ssh-auth publickey --ssh-key /home/awscli/.ssh/id_rsa --force-ssh --title "Amazon Web Services Client" --command /home/awscli/.local/bin/aws-shell
fi
return 0
