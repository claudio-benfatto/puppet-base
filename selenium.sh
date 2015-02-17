#!/bin/bash

#export AWS_ACCESS_KEY_ID=
#export AWS_SECRET_ACCESS_KEY=

function help {
echo "This script starts, stops or fetches the status of the Amazon AWS EC2 server i-1094b21c, known as Selenium."
exit
}

case "$1" in
        'start')
                /usr/bin/ec2-start-instances --region=us-west-2 i-1094b21c
                exit 0
                ;;
        'stop')
                /usr/bin/ec2-stop-instances --region=us-west-2 i-1094b21c
                exit 0
                ;;
        'status')
                /usr/bin/ec2-describe-instances --filter "instance-id=i-1094b21c" --region=us-west-2
                exit 0
                ;;
        'help')
                help
                exit 0
                ;;
        *)
                echo "Usage: $NAME {start|stop|status|help}" >&2
                exit 3
                ;;
esac
