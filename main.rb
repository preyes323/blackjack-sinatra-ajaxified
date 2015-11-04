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
  halt erb :buy_in if @error
  redirect '/game/bet'
end

get '/game/bet' do
  erb :bet
end

post '/game/bet' do
  set_bet(params[:money])
  halt erb :bet if @error
  deal_cards
  initialize_game_params
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
  session[:dealer_turn] = true if blackjack?(player_cards)
  if bust?(player_cards)
    session[:dealer_turn] = true
    session[:winner] = :dealer
    payout(session[:winner])
  end

  erb :game
end

post '/game/dealer_show' do
  if dealer_turn_end?
    session[:winner] = get_winner(player_cards, dealer_cards)
    payout(session[:winner])
  else
    hit(dealer_cards)
  end
  erb :game
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
