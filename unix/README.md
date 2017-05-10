# Some UNIX (Fedora/CentOS/RHEL) components used to deploy

+ __webhookListener.sh__ - An example script to be triggered by the ruby script

Run the following as root to prep the logfile used in the example script:
```
log=/var/log/webhookListener.log
touch $log
chmod 666 $log
```

