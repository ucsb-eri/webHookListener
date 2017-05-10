# webHookListener
ruby/sinatra github webhook listener

Webhook expected to be of type *application/x-www-form-urlencoded*

Need to set some environment variables before running the app:

+**WEBHOOK_LISTENER_SECRET_TOKEN** your github webhook secret string
+**WEBHOOK_LISTENER_BIND_ADDRESS** with the servers address to bind to
+**WEBHOOK_LISTENER_SCRIPT** script on the server running this to call
ie: 
```
export WEBHOOK_LISTENER_SECRET_TOKEN=NotMyRealSecretString
export WEBHOOK_LISTENER_BIND_ADDRESS=128.111.100.94
export WEBHOOK_LISTENER_SCRIPT=/opt/local/bin/myWebHookScript
ruby webhookListener.rb
```

The webhookListener.rb calls a unix shell script with the name of the repo initiating the webhook.
It can handle webhook calls from different repos, but they would all have to share a common Secret Token.
