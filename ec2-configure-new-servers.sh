#!/bin/bash
function help {
echo "This script calls the Amazon AWS EC2 servers in each zone to get a list of all running servers. It then compairs the IP addresses of the servers against to the configuration files of Munin and Bacula. If it finds an unused IP address it then goes on to match the name of a server with an existing config file and update the IP address, should not work then new configuration files are created."
exit
}


export AWS_ACCESS_KEY=****************************
export AWS_SECRET_KEY=****************************

# RESERVATION     r-6d7cb978      765404956144    production
# INSTANCE        i-23fd3736      ami-17a0090a    ec2-54-232-160-222.sa-east-1.compute.amazonaws.com      ip-10-253-166-120.sa-east-1.compute.internal    running claudio-sa-aws  0               m3.xlarge       2015-02-09T17:01:46+0000        sa-east-1b      aki-c48f51d9                    monitoring-disabled     54.232.160.222  10.253.166.120                  ebs                                     paravirtual     xen     VTONw1406127334790      sg-8773279a     default false   
# BLOCKDEVICE     /dev/sda1       vol-9cae7b91    2014-07-23T14:55:38.000Z        false           
# TAG     instance        i-23fd3736      Name    sa-syndicate-1b

function bacula-create {
tee "/etc/bacula/aws/${NAME}" <<EOF
JobDefs {
  Name = "${NAME}-Job"
  Type = Backup
  Level = Incremental
  Client = ${NAME}-fd
  FileSet = "${NAME} Set"
  Schedule = "WeeklyCycle"
  Storage = File
  Messages = Standard
  Pool = File
  Priority = 10
  Write Bootstrap = "/backup/%c.bsr"
}


Job {
  Name = "${NAME}-aws"
  JobDefs = "${NAME}-Job"
  Maximum Concurrent Jobs = 4
  Max Run Time = 360 min
}

Client {
  Name = ${NAME}-fd
  Address = ${ip}
  FDPort = 9102
  Catalog = MyCatalog
  Password = "cj2YENAsEeJk1nmMwipDtlUhi1XB8S3iw"          # password for FileDaemon
  File Retention = 30 days
  Job Retention = 6 months
  AutoPrune = yes
  Maximum Concurrent Jobs = 4
  Heartbeat Interval = 60
}

FileSet {
  Name = "${NAME} Set"
  Include {
    Options {
      signature = MD5
    }

    File = /etc
    File = /var/log
    File = /home
    File = /root
    Options { compression=GZIP }
  }

  Exclude {
    File = /home/ubuntu/.m2
    File = /var/lib/bacula
    File = /mnt
    File = /proc
    File = /tmp
    File = /.journal
    File = /.fsck
  }
}

EOF
chown bacula:bacula /etc/bacula/aws/${NAME}
}

function munin-update {
    echo "Munin $NAME on $ip in $region not found,"
    if [ -e /etc/munin/munin-conf.d/${NAME}.aws ]
    then
        echo "...updating."
        sed -i "s/address.*/address ${ip}/" /etc/munin/munin-conf.d/${NAME}.aws
    else
        echo "...creating."
        munin-create
    fi
}

function munin-create {
tee "/etc/munin/munin-conf.d/${NAME}.aws" <<EOF
[${NAME}.AWS]
    address ${ip}
    use_node_name yes
    if_err_eth0.contacts no
    if_eth0.contacts no
    if_err_eth1.contacts no
    if_eth1.contacts no
    apt_ubuntu.contacts no
#Instance ${ID}
#Zone ${region}
EOF
chown munin:munin /etc/munin/munin-conf.d/${NAME}.aws
}

function bacula-update {
    echo "Bacula config for $NAME on $ip in $region was not found,"
    if [ -e "/etc/bacula/aws/${NAME}" ]
    then
        echo "...updating."
        sed -i "s/Address.*/Address ${ip}/" /etc/bacula/aws/${NAME}
    else
        echo "...creating."
        bacula-create
    fi
}


[ -e ~/.ec2-full ] && rm ~/.ec2-full


for region in `ec2-describe-regions --aws-access-key AKIAI5DIK2FBRLRYUX3A --aws-secret-key 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|cut -f 2|tr '\n' ' '`
#us-east-1 us-west-1 us-west-2 eu-west-1 eu-central-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1
do
  [ -e ~/.ec2-dump ] && rm ~/.ec2-dump
  counter=1

  for ip in `ec2-describe-instances --filter "instance-state-code=16" --region=$region | tee -a ~/.ec2-dump | tee -a ~/.ec2-full |grep -v BLOCKDEVICE | cut -f 17| grep -v ^$`
  do
    INSTANCE=`grep ^INSTANCE  ~/.ec2-dump|head --lines=$counter|tail -1`
    TAG=`grep ^TAG  ~/.ec2-dump|head --lines=$counter|tail -1`
    ID=`echo $TAG|cut -d" " -f 3`
    if [[ $TAG == *"Name"* ]]
      then
      NAME=`echo $TAG|cut -d" " -f 5`
      else
      NAME=$ID
    fi
    #NAME=`grep Name  ~/.ec2-dump|tail -1|cut -f 5||echo "Unnamed"`
    grep $ip /etc/munin/munin-conf.d/*aws > /dev/null || munin-update
    grep $ip /etc/bacula/aws/* > /dev/null || bacula-update
    counter=`expr $counter + 1`
  done
done
exit

#Example of ec2-describe-instances output
RESERVATION     r-6d7cb978      765404956144    production
INSTANCE        i-23fd3736      ami-17a0090a    ec2-54-232-160-222.sa-east-1.compute.amazonaws.com      ip-10-253-166-120.sa-east-1.compute.internal    running claudio-sa-aws  0               m3.xlarge       2015-02-09T17:01:46+0000        sa-east-1b      aki-c48f51d9                    monitoring-disabled     54.232.160.222  10.253.166.120                  ebs                                     paravirtual     xen     VTONw1406127334790      sg-8773279a     default false
BLOCKDEVICE     /dev/sda1       vol-9cae7b91    2014-07-23T14:55:38.000Z        false
TAG     instance        i-23fd3736      Name    sa-syndicate-1b
