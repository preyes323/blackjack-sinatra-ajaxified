module Blackjack
  include Comparable
  INVALID_MONEY = -1
  MULTIPLE = 10

  def authenticated?
    @error = 'Input player name first!' unless player_name
    player_name
  end

  def set_player_name(name)
    if name.rstrip.empty?
      @error = 'No name given'
      session[:player_name] = nil
    else
      session[:player_name] = name
    end
  end

  def player_name
    session[:player_name]
  end

  def set_buy_in(money)
    money = numeric?(money) ? Integer(money) : INVALID_MONEY
    session[:buy_in] = money if valid_input?(money) && valid_value?(money)
  end

  def set_bet(bet)
    bet = numeric?(bet) ? Integer(bet) : INVALID_MONEY
    if valid_input?(bet) && valid_value?(bet) && valid_bet?(money, bet)
      session[:bet] = bet
    end
  end

  def with_buy_in?
    session[:buy_in]
  end

  def money
    session[:buy_in]
  end

  def bet
    session[:bet]
  end

  def deal_cards
    session[:deck] = shuffle_cards
    session[:player_cards] = []
    session[:dealer_cards] = []
    2.times do
      session[:dealer_cards] << deck.pop
      session[:player_cards] << deck.pop
    end
  end

  def player_cards
    session[:player_cards]
  end

  def dealer_cards
    session[:dealer_cards]
  end

  def deck
    session[:deck]
  end

  def calculate_total(cards)
    total = cards.collect do |card|
      case card[1]
      when '2'..'10'
        card[1].to_i
      when 'J', 'Q', 'K'
        10
      else
        0
      end
    end.reduce(:+)
    cards.each do |card|
      if card[1] == 'A'
        if (total + 11) > 21
          total += 1
        else
          total += 11
        end
      end
    end
    total
  end

  def hit(cards)
    cards << deck.pop
  end

  def dealer_turn_end?
    calculate_total(dealer_cards) > 17 || bust?(dealer_cards) || blackjack?(dealer_cards)
  end

  def bust?(cards)
    calculate_total(cards) > 21
  end

  def blackjack?(cards)
    calculate_total(cards) == 21
  end

  def get_winner(player_cards, dealer_cards)
    if bust?(player_cards) && bust?(dealer_cards)
      return :tie
    elsif bust?(player_cards) && !bust?(dealer_cards)
      return :dealer
    elsif !bust?(player_cards) && bust?(dealer_cards)
      return :player
    end
    player_value = calculate_total(player_cards)
    dealer_value = calculate_total(dealer_cards)
    return :tie if player_value == dealer_value
    player_value > dealer_value ? :player : :dealer
  end

  def payout(winner)
    if winner == :player
      if blackjack?(player_cards)
        session[:buy_in] += bet * 2
      else
        session[:buy_in] += bet
      end
    elsif winner == :dealer
      session[:buy_in] -= bet
    end
  end

  def initialize_game_params
    session[:dealer_turn] = false
    session[:winner] = nil
  end

  def card_image(card)
    suit = case card[0]
           when 'H' then 'hearts'
           when 'D' then 'diamonds'
           when 'S' then 'spades'
           when 'C' then 'clubs'
           end
    value = card[1]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[1]
              when 'J' then 'jack'
              when 'Q' then 'queen'
              when 'K' then 'king'
              when 'A' then 'ace'
              end
    end

    if !session[:dealer_turn] && card == dealer_cards.first
      "<img src='/images/cards/cover.jpg' class='card_image'>"
    else
      "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
    end
  end

  def display_winning_message(winner)
    case winner
    when :player
      %Q(<div class='row alert alert-success'>
         <h4>#{player_name} wins $#{bet}</h4>
         <p>Total money is now $#{money}</p>
         </div>)
    when :dealer
      %Q(<div class='row alert alert-error'>
         <h4>#{player_name} loses $#{bet}</h4>
         <p>Total money is now $#{money}</p>
         </div>)
    when :tie
      %Q(<div class='row alert alert-info'>
         <h4>Nobody won!</h4>
         <p>Total money is still $#{money}</p>
         </div>)
    end

  end

  private

  def shuffle_cards
    %w(H D S C).product(%w(A 2 3 4 5 6 6 7 9 J Q K)).shuffle
  end

  def valid_value?(money)
    result = money.modulo(MULTIPLE) == 0
    @error = "Money must be a multiple of #{MULTIPLE}" unless result
    result
  end

  def valid_input?(money)
    result = money > 0
    @error = 'Money must be greater than 0' unless result
    result
  end

  def valid_bet?(money, bet)
    result = bet <= money
    @error = 'Bet must not bet greater than money' unless result
    result
  end

  def numeric?(num)
    !!Integer(num) rescue false
  end

  def <=>(another_hand)
    if bust? && bust?
      return 0
    elsif bust? && !another_hand.bust?
      return -1
    elsif !bust? && another_hand.bust?
      return 1
    end
    hand_value = calculate_total
    another_hand_value = another_hand.calculate_total
    return 0 if hand_value == another_hand_value
    hand_value > another_hand_value ? 1 : -1
  end
end
