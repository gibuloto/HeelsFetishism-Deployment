#!/bin/bash

# <udf name="HOSTNAME" label="Hostname" />
# <udf name="PRIVATE_IP" label="Private IP to install to eth0:0" />
# <udf name="SALT_MASTER_IP" label="salt-master IP" />

function set_hostname {
    rm /etc/hostname
    echo $HOSTNAME > /etc/hostname
}

function set_private_ip {
    cat >>/etc/network/interfaces <<EOF

auto eth0:0
iface eth0:0 inet static
 address $PRIVATE_IP
 netmask 255.255.128.0
EOF

    /etc/init.d/networking restart
}

function setup_salt_minion {
    apt-get install wget

    # install salt-minion
    wget -O - http://bootstrap.saltstack.org | sudo sh

    echo "master: $SALT_MASTER_IP" >> /etc/salt/minion
}

function restart_salt_minion {
    # /etc/init.d/salt-minion restart
    service salt-minion restart
}

set_hostname
set_private_ip

setup_salt_minion
restart_salt_minion

sleep 10

reboot
