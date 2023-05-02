require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    "Hello, world!"
  end

  get '/hello' do
    name = params[:name]
    return "Hello, #{name}"
  end

  get '/posts' do
    name = params[:name]
    return "A list of #{name}'s posts:"
  end
  # http://localhost:9292/posts?name=Jack
  # => "A list of Jack's posts"

  post '/posts' do
    title = params[:title]
    return "Post was created with title: '#{title}'"
  end

  post '/submit' do
    name = params[:name]
    message = params[:message]

    return "Thanks #{name}, you sent this message: #{message}"
  end

  get '/names' do
    return "Julia, Mary, Karim"
  end

  post '/sort-names' do
    names = params[:names]
    final = names.split(',').sort.join(',')
    return final
  end
end