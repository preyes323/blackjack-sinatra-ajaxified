require 'rubygems'
require 'sinatra'
require 'pry'
require_relative 'blackjack_helpers'
require_relative 'error_handler'

use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: 'your_secret'

get_player_name = lambda do
  erb :player_name
end

get '/', &get_player_name
get '/player_name', &get_player_name

post '/player_name' do
  set_player_name(params[:player_name])
  redirect errors ? '/' : '/buy_in'
end

get '/buy_in' do
  erb :buy_in
end

post '/buy_in' do
  buy_in(params[:money])
  redirect errors ? '/buy_in' : '/bet'
end

get '/bet' do
  erb :bet
end

helpers ErrorHandler, Blackjack
