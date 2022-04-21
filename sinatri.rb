#!/usr/bin/env ruby
# Id$ nonnax 2022-04-20 19:39:41 +0800
class Response<Rack::Response; end
module Sinatri
  a, mapping=Rack::Builder.new, Hash.new{|h, k| h[k]={}}
  define_method(:app){ a }
  %w[get post put delete].map do |m|
    define_method(m) do |u, &b|
      mapping[u][m.upcase]=b
      a.map(u) do        
        run ->(e){
          status=200
          rm, pi=e.values_at('REQUEST_METHOD', 'REQUEST_PATH')
          body=a.instance_eval(&mapping[pi][rm]) rescue nil
          status=404; body='Oh oh' unless body
          [status, { 'Content-Type' => 'text/html' }, [body]]
      } 
      end
    end
  end  
end

include Sinatri
