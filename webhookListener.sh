#!/bin/sh
# need to make sure that the user running the webhookListener.rb script can run this script and write to the log
#
log=WH_SCRIPTLOG

ds=`date +'%Y%m%d-%H%M%S'`
echo "######################################" >> $log
echo "# caller: $0" >> $log
echo "# args: $@" >> $log
echo "# datestamp: $ds" >> $log
echo "# user: $USER" >> $log

[ $# -lt 2 ] && { echo "# Warning: script called without enough args" >> $log; exit 2 ; }

repo=$1; shift
event=$1; shift

update_waves_website(){
    lockfile=/tmp/webhookListener-waves-website-lock
    # want to avoid overlapping jekyll builds, so a lockfile is a real good idea
    [ -f $lockfile ] && { echo "# WARNING: Lockfile $lockfile exists, possibly a second webhook event before the first f
inished???" >> $log ; return 1; }
    touch $lockfile
    echo "cd to /home/caylor-lab/waves_website" >> $log
    cd /home/caylor-lab/waves_website
    echo "Initiating git pull and jekyll build" >> $log
    # The jekyll build can take a long time, but we need the overall webhook process
    # to complete in a reasonable amount of time, so a backgrounded subshell should do the trick
    (git pull >> $log 2>&1 ; ~/bin/jekyll build >> $log 2>&1 ; rm $lockfile; ) &
}

# Ultimately this needs to be called only on the appropriate events, but for testing we will do this.
case $repo in
    waves_sebsite)    update_waves_website ;;
    *)                echo "# Not configured to handle events for repo: $repo" >> $log  ;;
esac
