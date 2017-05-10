# Some UNIX (Fedora/CentOS/RHEL) components used to deploy

+ __webhookListener.sh__ - An example script to be triggered by the ruby script
+ __webhookListener.service__ - systemd script to start the ruby/sinatra listener service

Run the following as root to prep the logfile used in the example script:
```
log=/var/log/webhookListener.log
touch $log
chmod 666 $log
```

As root:
+ Setup some variables to help make this simpler, maybe will add a script to help with this later :-)
  + WHUSER=aaron
  + WHGROUP=aaron
  + WHENV=/etc/sysconfig/webhookListener
  + WHRUBYSCRIPT=/var/www/vhosts/webhookListener.rb
  + WHBINDIR=/opt/local/bin
  + WHSCRIPT=webhookListener.sh
  + WHSVCDIR=/lib/systemd/system
  + WHSVC=webhookListener.service
+ Setup the shell script that will be called by the ruby script:
  + mkdir -p $WHBINDIR 
  + cp $WHSCRIPT $WHBINDIR 
  + chown $WHUSER $WHBINDIR/$WHSCRIPT
+ Setup the systemd service:
  + cat $WHSVC | sed -e "s/WHUSER/$WHUSER/" -e "s/WHGROUP/$WHGROUP/" -e "s/WHRUBYSCRIPT/$WHRUBYSCRIPT/" -e "s/WHENV/$WHENV/"  > $WHSVCDIR/$WHSVC
  + verify that the systemctl service file has been modified successfully
    + cat /lib/systemd/system/webhookListener.service
  + systemctl enable webhookListener
  + systemctl start webhookListener

