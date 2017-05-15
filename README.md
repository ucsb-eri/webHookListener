# webHookListener
ruby/sinatra github webhook listener

## Background
The driving goal of this repo was to trigger updating and publishing of a github
based jekyll website repo on one of our web servers (Fedora-25).  More specifically,
that website repo has a deploy branch.  Pushes to that branch should trigger a pull
on the local server and a jekyll rebuild (update the _site folder).

## Github Prep
**NOTE**: The github docs on this are great and are likely more help that this quick summary :-)
+ Navigate to the repo you want to initiate webhooks
+ Click on **Settings** tab (near top of repo display)
+ Click on **Webhooks** menu item (on left hand side)
+ Click on **Add webhook**
  + Specify the **Payload URL**
  + Select **Content Type**: The script here expects the type to be: _application/x-www-form-urlencoded_
  + Specify **Secret** Token: can be any string.  You will need that validate the payload on your server

## Server side Goodies
Some of the following is a bit deprecated as I did set up an install script to
assist in a systemctl install, but will leave in for historic reference/context.

### Historic
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

Once the above is done, you should be able to read the README-FC+RHEL+CENTOS.md file and then install the components on the server using the Install script.

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


### Downstream Installation Notes - waves_website specific
As root:
+ dnf install ImageMagick ImageMagick-devel
+ dnf install libxml2 libxml2-devel
+ dnf install libxslt libxslt-devel

As regular user:
+ bundle config build.nokogiri --use-system-libraries
+ bundle install
