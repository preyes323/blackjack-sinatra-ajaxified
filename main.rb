require 'rubygems'
require 'sinatra'
require 'pry'
require_relative 'blackjack_helpers'

use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: 'your_secret'

get_player_name = lambda do
  erb :player_name
end

get '/', &get_player_name
get '/player_name', &get_player_name

post '/player_name' do
  session[:player_name] = params[:player_name]
  redirect session[:player_name].empty? ? '/' : '/buy_in'
end

get '/buy_in' do
  erb :buy_in
end

post '/buy_in' do
  
end

helpers Blackjack
