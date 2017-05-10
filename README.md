# webHookListener
ruby/sinatra github webhook listener

Webhook expected to be of type *application/x-www-form-urlencoded*

Need to set some environment variables before running the app:

+ **WEBHOOK_LISTENER_SECRET_TOKEN** your github webhook secret string
+ **WEBHOOK_LISTENER_BIND_ADDRESS** with the servers address to bind to
+ **WEBHOOK_LISTENER_SCRIPT** script on the server running this to call

ie: 
```
export WEBHOOK_LISTENER_SECRET_TOKEN=NotMyRealSecretString
export WEBHOOK_LISTENER_BIND_ADDRESS=128.111.100.94
export WEBHOOK_LISTENER_SCRIPT=/opt/local/bin/myWebHookScript
ruby webhookListener.rb
```

The webhookListener.rb calls a unix shell script with two arguments:
+ The name of the repo initiating the webhook
+ The event type that initiated the webhook

This allows the listener to handle webhook calls from different repos, but they would all have to share a common Secret Token.

## Installation - Fedora-25
As root:
+ dnf install ruby ruby-devel rubygems
+ If you are running a firewall, remember to poke a hole for port 4567 (sinatra default port)

As a regular user (possibly the account that will run the above?)
+ gem install sinatra

## Downstream Installation - Fedora-25
The motivation for this webhookListener project is to allow automated building of jekyll sites following a github webhook push event.
Barring finding a more appropriate location for this, some of the downstream documentation will be kept here (at least for now).

Need to get jekyll installed.  Should refer to the install instructions on the jekyll website, but will try to maintain a quick summary here as well as OS specific install issues NOT covered on the jekyll website.

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
