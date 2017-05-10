#!/bin/sh
WH_USER=aaron
WH_GROUP=aaron
WH_SYSCONFIGDIR=/etc/sysconfig
WH_SYSCONFIGFILE=webhookListener
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

file=$WH_SCRIPTBINDIR/$WH_SCRIPTSHELL
if [ -f "$file" ]; then
    echo "$file already exists, no changes"
else
    echo "Installing $WH_SCRIPTSHELL in $WH_SCRIPTBINDIR:"
    cat $WH_SCRIPTSHELL | sed -e "s:WH_SCRIPTLOG:$WH_SCRIPTLOG:" > $file
    [ $? -eq 0 ] || { echo "unable to create script: $file"; exit 1; }  
fi
chown $WH_USER $file
chmod 755 $file

file=$WH_SYSCONFIGDIR/$WH_SYSCONFIGFILE
if [ -f "$file" ]; then
    echo "$file already exists, no changes"
else
    echo "Installing $WH_SYSCONFIGFILE in $WH_SYSCONFIGDIR:"
    cat $WH_ENV | sed -e "s:WH_SCRIPTSHELL:$WH_SCRIPTSHELL:" > $file
    [ $? -eq 0 ] || { echo "unable to create script: $file"; exit 1; }  
fi
chmod 666 $file


file=$WH_SCRIPTBINDIR/$WH_SCRIPTRUBY
if [ -f "$file" ]; then
    echo "$file already exists, no changes"
else
    echo "Installing $WH_SCRIPTRUBY in $WH_SCRIPTBINDIR:"
    cat $WH_SCRIPTRUBY  > $file
    [ $? -eq 0 ] || { echo "unable to create script: $file"; exit 1; }  
fi
chown $WH_USER $file
chmod 755 $file

file="$WH_SVCDIR/$WH_SVCFILE"
if [ -f "$file" ]; then
    echo "$WH_SVCDIR/$WH_SVCFILE already exists, no changes"
else
    echo "Installing/Configuring the systemd service ($file):"
    cat $WH_SVCFILE | sed \
        -e "s:WH_USER:$WH_USER:" \
        -e "s:WH_GROUP:$WH_GROUP:" \
        -e "s:WH_ENV:$WH_SYSCONFIGDIR/$WH_SYSCONFIGFILE:" \
        -e "s:WH_SCRIPTRUBY:$WH_SCRIPTBINDIR/$WH_SCRIPTRUBY:" \
	> $file
fi
#cat $file

echo "Manually Enable/Start/Stop the webhookListener systemd service with commands:"
echo "  systemctl enable webhookListener"
echo "  systemctl start webhookListener"
echo "  systemctl stop webhookListener"
