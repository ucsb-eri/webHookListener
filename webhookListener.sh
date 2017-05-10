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
    lockfile=/tmp/webhookListener-waves-website-lock
    [ -f $lockfile ] && { echo "# WARNING: Lockfile $lockfile exists, possibly a second webhook event before the first finished???" >> $log ; return 1; }
    touch $lockfile
    echo "cd to /home/caylor-lab/waves_website" >> $log
    cd /home/caylor-lab/waves_website
    echo "Initiating jekyll build" >> $log
    # The following can take a long time, but we need the overall webhook process to finish in a reasonable amount of time
    (~/bin/jekyll build >> $log 2>&1 ; rm $lockfile; ) &
}

# Ultimately this needs to be called only on the appropriate events, but for testing we will do this.
update_waves_website
