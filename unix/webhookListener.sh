#!/bin/sh
# need to make sure that the user running the webhookListener.rb script can run this script and write to the log
# 
log=/var/log/webhook.log

ds=`date +'%Y%m%d-%H%M%S'`
echo "######################################" >> $log
echo "# caller: $0" >> $log
echo "# args: $@" >> $log
echo "# datestamp: $ds" >> $log
echo "# user: $USER" >> $log
