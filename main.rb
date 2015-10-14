require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: 'your_secret'

get '/' do
  erb :set_name
end

post '/set_name' do
  session[:player_name] = params[:player_name]
  redirect session[:player_name].empty? ? '/' : '/set_bet'
end

get '/set_bet' do
  erb :set_bet
end

post '/set_bet' do

end

get '/game' do
  erb :game
end
