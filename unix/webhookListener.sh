#!/bin/sh
# need to make sure that the user running the webhookListener.rb script can run this script and write to the log
# 
log=/var/log/webhookListener.log

ds=`date +'%Y%m%d-%H%M%S'`
echo "######################################" >> $log
echo "# caller: $0" >> $log
echo "# args: $@" >> $log
echo "# datestamp: $ds" >> $log
echo "# user: $USER" >> $log

update_waves_website(){
    cd /home/caylor-lab/waves_website
    jekyll build >> $log
}

# Ultimately this needs to be called only on the appropriate events, but for testing we will do this.
update_waves_website
