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

[ $# -lt 2 ] && { echo "# Warning: script called without enough args" >> $log; exit 2 ; }

while [ $# -ne 0 ]; do
    case $1 in 
        --repo=*)    repo=`echo "$1" | cut -d= -f2-`  ;;
        --ref=*)     ref=`echo "$1" | cut -d= -f2-`  ;;
        --event=*)   event=`echo "$1" | cut -d= -f2-`  ;;
        --*)         echo "Unrecognized argument: $1"   ;;
        *)           break ;;
    esac
    shift
done

#repo=$1; shift
#event=$1; shift

update_waves_website(){
    process_ref="refs/heads/deploy"
    project="waves-website"
    [ "$ref" = "$process_ref" ] || { echo "repo: $repo, processes only ref: $process_ref, not sure what to do with: $ref" >> $log; return ; }

    lockfile=/tmp/webhookListener-$project-lock
    # want to avoid overlapping jekyll builds, so a lockfile is a real good idea
    [ -f $lockfile ] && { echo "# WARNING: Lockfile $lockfile exists, possibly a second webhook event before the first f
inished???" >> $log ; return 1; }
    touch $lockfile
    echo "cd to /home/caylor-lab/waves_website" >> $log
    cd /home/caylor-lab/waves_website
    echo "Initiating git pull and jekyll build for: $project" >> $log
    # The jekyll build can take a long time, but we need the overall webhook process
    # to complete in a reasonable amount of time, so a backgrounded subshell should do the trick
    (git pull origin deploy >> $log 2>&1 ; ~/bin/jekyll build >> $log 2>&1 ; rm $lockfile; ) &
}

update_jekTest(){
    process_ref="refs/heads/deploy"
    project=jekTest
    [ "$ref" = "$process_ref" ] || { echo "repo: $repo, processes only ref: $process_ref, not sure what to do with: $ref" >> $log; return ; }

    lockfile=/tmp/webhookListener-$project-lock
    # want to avoid overlapping jekyll builds, so a lockfile is a real good idea
    [ -f $lockfile ] && { echo "# WARNING: Lockfile $lockfile exists, possibly a second webhook event before the first f
inished???" >> $log ; return 1; }
    touch $lockfile
    echo "Getting into processing payload: repo: $repo, event: $event, ref: $ref" >> $log
    cd /home/aaron/sites/jekTest
    echo "Initiating git pull and jekyll build for: $project" >> $log
    # The jekyll build can take a long time, but we need the overall webhook process
    # to complete in a reasonable amount of time, so a backgrounded subshell should do the trick
    (git pull origin deploy >> $log 2>&1 ; ~/bin/jekyll build >> $log 2>&1 ; rm $lockfile; ) &
}
# Ultimately this needs to be called only on the appropriate events, but for testing we will do this.
case $repo in
    waves_website)    update_waves_website ;;
    jekTest)          update_jekTest ;;
    *)                echo "# Not configured to handle events for repo: $repo" >> $log  ;;
esac
