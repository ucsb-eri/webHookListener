# webHookListener
ruby/sinatra github webhook listener service.

This install specifically configures for Fedora/RHEL/CentOS at this time, but
could be ported (pretty easily) to other linux variants.

Current install at spin:/opt/local/bin

## Background
The driving goal of this repo was to trigger updating and publishing of a github
based jekyll website repo on one of our web servers (Fedora-25).  More specifically,
that website repo has a deploy branch.  Pushes to that branch should trigger a pull
on the local server and a jekyll rebuild (update the _site folder).

## Github Prep
**NOTE**: The github docs on this are great and are likely more help than this quick summary :-)
+ Navigate to the repo you want to initiate webhooks
+ Click on **Settings** tab (near top of repo display)
+ Click on **Webhooks** menu item (on left hand side)
+ Click on **Add webhook**
  + Specify the **Payload URL**
  + Select **Content Type**: The script here expects the type to be: _application/x-www-form-urlencoded_
  + Specify **Secret** Token: can be any string.  You will need that validate the payload on your server

## Server Side Components
### General overview:
+ **webhookListener.service** - systemctl driven launcher for the ruby script:
  + utilizes EnvironmentFile to setup the environment variables that the ruby/sintra script requires
  + run as non-privileged user.
  + service can be used as target for different/multiple repos.
+ **webhookListener** - EnvironmentFile used by systemctl:
  + edit as needed
  + drop in **/etc/sysconfig** by Install script.
+ **webhookListener.rb** - ruby/sinatra script:
  + simple webserver that listens on localhost:4567 by default.
  + single script can process events for different github repos.
  + validates credentials using **Secret** token.
  + fires off a shell script:
    + with arguments derived from the github event payload.
    + shell was chosen for familiarity (not well versed in ruby (YET)).  
    + same functionality could be achieved with ruby.
    + runs as the same user ruby/sintra script is running under.
+ **webhookListener.sh** - shell script that ultimately deals with the builds:
  + parses input arguments.
  + choose subroutine to run based on logic using those arguments.
  + performs some real basic file locking (so multiple events do not overlap).
  + backgrounds jekyll rebuild (+logging, unlocking, etc...):
    + prevents timeout *"failures"* due to blocking I/O that may not return in time
  + some logging to /var/log/webhookListner.log

### Historic
This section is mostly deprecated by the addition of an install script, but has
been left for historic context/reference :-)

Need to set some environment variables before running the app:

+ **WEBHOOK_LISTENER_SECRET_TOKEN** your github webhook secret string
+ **WEBHOOK_LISTENER_BIND_ADDRESS** with the servers address to bind to
+ **WEBHOOK_LISTENER_SCRIPTSHELL** script on the server running this to call

ie:
```
export WEBHOOK_LISTENER_SECRET_TOKEN=NotMyRealSecretString
export WEBHOOK_LISTENER_BIND_ADDRESS=128.111.100.94
export WEBHOOK_LISTENER_SCRIPTSHELL=/opt/local/bin/webhookListener.sh
ruby webhookListener.rb
```

The webhookListener.rb calls a unix shell script with some arguments pulled from the payload:
+ The name of the repo initiating the webhook
+ The event type that initiated the webhook
+ The ref string associated with pull events (events are contextual, so not all provide the ref)

This allows the listener to handle webhook calls from different repos, but they would all have to share a common Secret Token.

## Server Side Installation - Fedora-25
As root:
+ dnf install ruby ruby-devel rubygems
+ If you are running a firewall, remember to poke a hole for port 4567 (sinatra default port)

As a regular user (possibly the account that will run the above?)
+ gem install sinatra

Once the above is done:
+ read the README-FC+RHEL+CENTOS.md file.
+ edit Install script and customize paths, Secret tokens etc... to match your install.
+ run the script.

## Server Side Downstream Installation - Fedora-25
The motivation for this webhookListener project is to allow automated building of jekyll sites following a github webhook push event.
Barring finding a more appropriate location for this, some of the downstream documentation will be kept here (at least for now).

Need to get jekyll installed.  
Should refer to the install instructions on the jekyll website, but will try to maintain a quick
summary here as well as OS specific install issues NOT covered on the jekyll website.

As root:
+ dnf install gcc redhat-rpm-config

As a regular user:
+ gem install jekyll bundler

## Server Side OS updates/upgrades/issues
&#x1F53A; current deployment (2018-06) is at spin:/home/caylor-lab/waves_website
### Fedora-25
Have seen issues with OS updates/upgrades breaking the user ruby/gem environment.
I dont understand that landscape enough to understand exactly what got broken.  
Putzing around with various things eventually seemed to repair the issue.

Gemfile.lock requires specific versions of gems.  I believe that's built by bundler (gem manager).
Instead of running jekyll directly, seems like it may be better to run as:
```
bundler exec jekyll build
```
Since I am running the ruby webhook listener under a non-privileged user account, once the account environment is fixed, both jekyll and sinatra should behave themselves.

### Fedora-26 (updates)
OS updates/upgrades broke ruby/gem environment again.

```
bundler install
```

The above caused rebuilds/reinstalls of:
* ffi
* nokogiri
* rmagick

Tried to run bundler exec jekyll build - but had a typo not caught - thought I needed to reinstall jekyll which I did as user
```
gem install jekyll
```

Caught typo and was able to successfully run
```
bundler exec jekyll build
```

### Fedora-29 ###
The below was suggested after a bundle install attempt.
```
cd /home/caylor-lab/waves_website
bundle install --path vendor/bundle
```

Still a number of warnings and such at the top of the installation.
### Downstream Installation Notes - waves_website specific
As root:
+ dnf install ImageMagick ImageMagick-devel
+ dnf install libxml2 libxml2-devel
+ dnf install libxslt libxslt-devel

As regular user:
+ bundle config build.nokogiri --use-system-libraries
+ bundle install
