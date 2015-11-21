require 'rubygems'
require 'sinatra'
require 'pry'
require_relative 'blackjack_helpers'

use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: 'your_secret'

get_player_name = lambda do
  session[:game_start] = nil
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
  halt erb :buy_in if @error
  redirect '/game/bet'
end

get '/game/bet' do
  session[:game_start] = false
  erb :bet
end

post '/game/bet' do
  set_bet(params[:money])
  halt erb :bet if @error
  deal_cards
  set_possible_moves
  initialize_game_params
  redirect '/game'
end

get '/game' do
  check_player_status
  check_dealer_status if session[:dealer_turn]
  erb :game
end

post '/game/player_stay' do
  session[:dealer_turn] = true
  redirect '/game'
end

get '/game/update' do
  check_player_status
  check_dealer_status if session[:dealer_turn]
  erb :game, layout: false
end

post '/game/player_hit' do
  hit(player_cards)
  session[:dealer_turn] = true if blackjack?(player_cards)
  redirect '/game/update'
end

post '/game/player_double' do
  double_bet
  halt erb :game if @error
  hit(player_cards)
  session[:dealer_turn] = true
  if bust?(player_cards)
    session[:winner] = :dealer
    payout(session[:winner])
  end
  redirect '/game'
end

post '/game/dealer_show' do
  hit(dealer_cards)
  redirect '/game'
end

before '/game*' do
  halt erb :player_name unless authenticated?
end

before '/game' do
  unless with_buy_in?
    @error = 'Input buy-in amount first'
    halt erb :buy_in
  end
end

helpers Blackjack
