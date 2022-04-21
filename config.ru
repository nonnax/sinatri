#!/usr/bin/env ruby
# Id$ nonnax 2022-04-20 19:42:09 +0800
require_relative 'sinatri'

get '/' do
  'hello'
end

get '/hi' do
  'hi too'
end

run Sinatri.app
