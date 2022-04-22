#!/usr/bin/env ruby
# Id$ nonnax 2022-04-20 19:39:41 +0800
require 'securerandom'
class Response<Rack::Response; end # session error fix
module Sinatri
  D,H=Object.method(:define_method),Hash.new{|h,k| h[k]=k.transform_keys(&:to_sym)}
  PATTERN=Hash.new{|h, path| h[path]=path.to_s.gsub(/:\w+/){ |match| '([^/?#]+)' }.then{|p| /^(#{p})\/?$/ }  }
  a, mapping,req=Rack::Builder.new, Hash.new{|h, k| h[k]={}}
  D.(:mappings){ mapping }
  %w[get post put delete handle].map do |m|
    D.(m) do |u, &b| mapping[PATTERN[u]][m.upcase]=b end
  end  

  D.(:app) do
    a.run ->(e){
      status=200
      rm, pi, md = req.request_method, req.path_info
      _, m = mapping.detect{|u, _| md=pi.match(u)}
      _, *vars= Array(md&.captures)
      body=a.instance_exec(*vars, H[req.params], &m[rm]) rescue nil
      unless body
        status=404; body=instance_eval(&mapping[PATTERN[404]]['HANDLE'])
      end
      [status, { Rack::CONTENT_TYPE => 'text/html' }, [body]]
    } 
    a  
  end

  %w[params session].map { |m| D.(m) { req.send m } }
  a.use Rack::Session::Cookie, secret: SecureRandom.hex(64)
  a.use Rack::Lock
  D.(:before) do |&b|
    a.use Rack::Config, &b
  end
  before do |e|
    req = Rack::Request.new e
    req.params.dup.map do |k, v|
      params[k.to_sym] = v
    end
  end 
  handle 404 do
    'Not Found'
  end  
end
include Sinatri
