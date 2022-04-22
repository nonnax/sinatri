#!/usr/bin/env ruby
# Id$ nonnax 2022-04-20 19:42:09 +0800
require_relative 'lib/sinatri'

get '/' do
  session[:name]='nonnax'
  p 'hello'
end

get '/:hi' do |hi|
  name=String(session[:name])
  'hi,'+String(hi)+' '+name
end

handle '404' do
  'UnFound'
end

pp Sinatri.mappings
run Sinatri.app
