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

echo "Checking on the $WH_SCRIPTBINDIR install destination:"
if [ ! -d "$WH_SCRIPTBIDIR" ]; then
    mkdir -p $WH_SCRIPTBINDIR
    [ $? -eq 0 ] || { echo "unable to create bin dir: $WH_SCRIPTBINDIR"; exit 1; }  
fi

echo "Installing $WH_SCRIPTSHELL in $WH_SCRIPTBINDIR:"
file=$WH_SCRIPTBINDIR/$WH_SCRIPTSHELL
if [ -f "$file" ]; then
    cat $WH_SCRIPTSHELL | sed -e "s/WH_SCRIPTLOG/$WH_SCRIPTLOG/" > $file
    [ $? -eq 0 ] || { echo "unable to create script: $file"; exit 1; }  
else
    echo "$file already exists, no changes"
fi
chown $WH_USER $file

echo "Installing $WH_SCRIPTRUBY in $WH_SCRIPTBINDIR:"
file=$WH_SCRIPTBINDIR/$WH_SCRIPTRUBY
if [ -f "$file" ]; then
    cat $WH_SCRIPTRUBY  > $file
    [ $? -eq 0 ] || { echo "unable to create script: $file"; exit 1; }  
else
    echo "$file already exists, no changes"
fi
chown $WH_USER $file

echo "Installing/Configuring the systemd service:"
if [ -f "$WH_SVCDIR/$WH_SVCFILE" ]; then
    cat $WH_SVCFILE | sed \
        -e "s/WH_USER/$WH_USER/" \
        -e "s/WH_GROUP/$WH_GROUP/" \
        -e "s/WH_ENV/$WH_ENV/" \
        -e "s/WH_SCRIPTRUBY/$WH_SCRIPTRUBY/" \
	> $WH_SVCDIR/$WH_SVCFILE
else
    echo "$WH_SVCDIR/$WH_SVCFILE already exists, no changes"
fi
cat $WH_SVCDIR/$WH_SVCFILE

echo "Manually Enable/Start/Stop the webhookListener systemd service with commands:"
echo "  systemctl enable webhookListener"
echo "  systemctl start webhookListener"
echo "  systemctl stop webhookListener"
