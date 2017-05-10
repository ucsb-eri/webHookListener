#!/bin/sh
WHUSER=aaron
WHGROUP=aaron
WHENV=/etc/sysconfig/webhookListener
WHRUBYSCRIPT=/var/www/vhosts/webhookListener.rb
WHBINDIR=/opt/local/bin
WHSCRIPT=webhookListener.sh
WHSVCDIR=/lib/systemd/system
WHSVC=webhookListener.service
WHSVCLOG=webhookListenerSvc.log # not used at the moment
WHSCRIPTLOG=/var/log/webhookListener.log

echo "Prep the logfile"

[ ! -f "$WHSCRIPTLOG" ] && touch $WHSCRIPTLOG
chmod 664 $WHSCRIPTLOG
chown $WHUSER:$WHGROUP $WHSCRIPTLOG

echo "Setup the shell script that will be called by the ruby script:"
if [ ! -d "$WHBIDIR" ]; then
    mkdir -p $WHBINDIR
    [ $? -eq 0 ] || { echo "unable to create bin dir: $WHBINDIR"; exit 1; }  
fi

if [ -f "$WHSCRIPT" ]; then
    cat $WHSCRIPT | sed -e "s/WHSCRIPTLOG/$WHSCRIPTLOG/" > $WHBINDIR
    [ $? -eq 0 ] || { echo "unable to create script: $WHSCRIPT in dir: $WHBINDIR"; exit 1; }  
else
    echo "$WHSCRIPT already exists, no changes"
fi
chown $WHUSER $WHBINDIR/$WHSCRIPT


echo "Setup the systemd service:"
if [ -f "$WHSVCDIR/$WHSVC" ]; then
    cat $WHSVC | sed \
        -e "s/WHUSER/$WHUSER/" \
        -e "s/WHGROUP/$WHGROUP/" \
        -e "s/WHRUBYSCRIPT/$WHRUBYSCRIPT/" \
        -e "s/WHENV/$WHENV/" \
	> $WHSVCDIR/$WHSVC
else
    echo "$WHSVCDIR/$WHSVC already exists, no changes"
fi
cat $WHSVCDIR/$WHSVC

echo "Manually Enable/Start/Stop the webhookListener systemd service with commands:"

echo "systemctl enable webhookListener"
echo "systemctl start webhookListener"
echo "systemctl stop webhookListener"
