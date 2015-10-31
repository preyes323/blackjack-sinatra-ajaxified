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
  halt erb :player_name unless player_name
  redirect '/game/buy_in'
end

get '/game/buy_in' do
  erb :buy_in
end

post '/game/buy_in' do
  set_buy_in(params[:money])
  halt erb :buy_in if @errors
  redirect '/game/bet'
end

get '/game/bet' do
  erb :bet
end

post '/game/bet' do
  set_bet(params[:money])
  halt erb :bet if @errors
  deal_cards
  session[:dealer_turn] = false
  redirect '/game'
end

get '/game' do
  erb :game
end

post '/game/player_stay' do
  session[:dealer_turn] = true
  erb :game
end

post '/game/player_hit' do
  hit(player_cards)
  erb :game
end

before '/game*' do
  halt erb :player_name unless authenticated?
end

helpers ErrorHandler, Blackjack
