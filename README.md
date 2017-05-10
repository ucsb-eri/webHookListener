# webHookListener
ruby/sinatra github webhook listener

Webhook expected to be of type '''application/x-www-form-urlencoded'''

Must set the SECRET_TOKEN env var before running myapp.rb
EXAMPLE: export SECRET_TOKEN=HeyThereFakeSecretJustForFun
ruby webhookListener.rb
