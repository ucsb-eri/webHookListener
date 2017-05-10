# Some UNIX (Fedora/CentOS/RHEL) components used to deploy

+ __webhookListener.sh__ - An example script to be triggered by the ruby script
+ __webhookListener.service__ - systemd script to start the ruby/sinatra listener service
+ __Install.sh__ - shell script to help with installation of the script and service

## Installation of components:
+ Edit the Install.sh script and adjust the variables at the top to reflect the installation on your system.
+ sh ./Install.sh
+ The Install.sh variables and their usage are documented a bit below
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
