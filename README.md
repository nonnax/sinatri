# sinatri - baby sinatra 


```ruby

require 'sinatri'

get '/' do
  'hello'
end

get '/hi' do
  'hi too'
end

run Sinatri.app
```
