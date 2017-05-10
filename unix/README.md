# Some UNIX (Fedora/CentOS/RHEL) components used to deploy

+ __webhookListener.sh__ - An example script to be triggered by the ruby script
+ __webhookListener.service__ - systemd script to start the ruby/sinatra listener service
+ __Install.sh__ - shell script to help with installation of the script and service


Run the following as root to prep the logfile used in the example script:
```
log=/var/log/webhookListener.log
touch $log
chmod 666 $log
```
## Installation of components:
+ Edit the Install.sh script and adjust the variables at the top to reflect the installation on your system.
+ sh ./Install.sh
+ The Install.sh variables and their usage are documented a bit below
  + WHUSER=aaron       # User that webhookListener services should run as
  + WHGROUP=aaron      # Group that webhookListener services should run as
  + WHENV=/etc/sysconfig/webhookListener  # Environment Variables for the Ruby/Sinatra script added to this file for the systemd service
  + WHRUBYSCRIPT=/var/www/vhosts/webhookListener.rb   # Where the ruby script will live
  + WHBINDIR=/opt/local/bin
  + WHSCRIPT=webhookListener.sh
  + WHSVCDIR=/lib/systemd/system
  + WHSVC=webhookListener.service
  + WHSVCLOG=webhookListenerSvc.log   # not used at the moment
  + WHSCRIPTLOG=/var/log/webhookListener.log

+ Prep the logfile
  + touch $WHSCRIPTLOG
  + chmod 664 $WHSCRIPTLOG
  + chown $WHUSER:$WHGROUP $WHSCRIPTLOG
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

