#!/usr/bin/env ruby
require 'sinatra'
require 'json'

set :bind, ENV['WEBHOOK_LISTENER_BIND_ADDRESS']
#'128.111.100.94'

# We can have GET requests do something
get '/' do
  'This github webhook listener expects properly formatted/authorized POST payloads to initiate actions'
end

post '/payload' do
  request.body.rewind
  payload_body = request.body.read
  verify_signature(payload_body)
  push = JSON.parse(params[:payload])

  # The following is sent as a response to the payload request
  "I got some JSON: #{push.inspect}"
  #console.log('Hey There, just seein if this works')

  # Now we need to do fire off something else, either via ruby or a shell script
  reponame = push["repository"]["name"]
  event = request.env['HTTP_X_GITHUB_EVENT']
  system(ENV['WEBHOOK_LISTENER_SCRIPTSHELL'],reponame,event)
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['WEBHOOK_LISTENER_SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
