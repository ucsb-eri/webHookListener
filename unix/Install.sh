#!/bin/sh
WH_USER=aaron
WH_GROUP=aaron
WH_ENV=/etc/sysconfig/webhookListener
WH_SCRIPTBINDIR=/opt/local/bin
WH_SCRIPTRUBY=webhookListener.rb
WH_SCRIPTSHELL=webhookListener.sh
WH_SVCDIR=/lib/systemd/system
WH_SVCFILE=webhookListener.service
WH_SVCLOG=webhookListenerSvc.log # not used at the moment
WH_SCRIPTLOG=/var/log/webhookListener.log

echo "Prep the logfile"

[ ! -f "$WH_SCRIPTLOG" ] && touch $WH_SCRIPTLOG
chmod 664 $WH_SCRIPTLOG
chown $WH_USER:$WH_GROUP $WH_SCRIPTLOG

echo "Setup the shell script that will be called by the ruby script:"
if [ ! -d "$WH_BIDIR" ]; then
    mkdir -p $WH_SCRIPTBINDIR
    [ $? -eq 0 ] || { echo "unable to create bin dir: $WH_SCRIPTBINDIR"; exit 1; }  
fi

if [ -f "$WH_SCRIPTSHELL" ]; then
    cat $WH_SCRIPTSHELL | sed -e "s/WH_SCRIPTLOG/$WH_SCRIPTLOG/" > $WH_SCRIPTBINDIR
    [ $? -eq 0 ] || { echo "unable to create script: $WH_SCRIPTSHELL in dir: $WH_SCRIPTBINDIR"; exit 1; }  
else
    echo "$WH_SCRIPTSHELL already exists, no changes"
fi
chown $WH_USER $WH_SCRIPTBINDIR/$WH_SCRIPTSHELL


echo "Setup the systemd service:"
if [ -f "$WH_SVCDIR/$WH_SVCFILE" ]; then
    cat $WH_SVCFILE | sed \
        -e "s/WH_USER/$WH_USER/" \
        -e "s/WH_GROUP/$WH_GROUP/" \
        -e "s/WH_SCRIPTRUBY/$WH_SCRIPTRUBY/" \
        -e "s/WH_ENV/$WH_ENV/" \
	> $WH_SVCDIR/$WH_SVCFILE
else
    echo "$WH_SVCDIR/$WH_SVCFILE already exists, no changes"
fi
cat $WH_SVCDIR/$WH_SVCFILE

echo "Manually Enable/Start/Stop the webhookListener systemd service with commands:"

echo "systemctl enable webhookListener"
echo "systemctl start webhookListener"
echo "systemctl stop webhookListener"
