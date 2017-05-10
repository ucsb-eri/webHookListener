# Deploy on Fedora/CentOS/RHEL
An install script has been provided to ease installation on these platforms.  
The script helps get the following scripts/services properly configured.

+ __webhookListener.rb__ - The main ruby/sintra script that receives the webhook payload
+ __webhookListener.sh__ - The shell script called by the ruby script when an appropriate POST occurs
+ __webhookListener.service__ - systemd script to start the ruby/sinatra listener service
+ __Install-FC+RHEL+CENTOS.sh__ - shell script to help with installation of the scripts and service

## Installation of components:
+ Edit the Install script and adjust the variables at the top to reflect the installation on your system:
  + WH_USER=aaron                                # User that webhookListener services should run as
  + WH_GROUP=aaron                               # Group that webhookListener services should run as
  + WH_ENV=/etc/sysconfig/webhookListener        # Environment Variables for systemd service (provided to ruby/sinatra script)
  + WH_SCRIPTRUBY=webhookListener.rb             # Where the ruby script will live
  + WH_SCRIPTSHELL=webhookListener.sh            # sh script that the ruby/sinatra script calls when triggered appropriately
  + WH_SCRIPTBINDIR=/opt/local/bin               # location to install WH_SCRIPTSHELL and WH_SCRIPTRUBY
  + WH_SVCDIR=/lib/systemd/system                # location to install systemd service
  + WH_SVCDESC=webhookListener.service           # filename for systemd service
  + WH_SVCLOG=webhookListenerSvc.log             # not used at the moment
  + WH_SCRIPTLOG=/var/log/webhookListener.log    # log file that the WH_SCRIPTSHELL writes to
+ sh ./Install.sh
