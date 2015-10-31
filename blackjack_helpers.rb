module Blackjack
  INVALID_MONEY = -1
  MULTIPLE = 10

  def authenticated?
    add_error('Input player name first!') unless player_name
    player_name
  end

  def set_player_name(name)
    if name.rstrip.empty?
      add_error('No name given')
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
    session[:bet] = bet if valid_input?(bet) && valid_bet?(money, bet)
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

  private

  def shuffle_cards
    %w(H D S C).product(%w(A 2 3 4 5 6 6 7 9 J Q K)).shuffle
  end

  def valid_value?(money)
    result = money.modulo(MULTIPLE) == 0
    add_error("Money must be a multiple of #{MULTIPLE}") unless result
    result
  end

  def valid_input?(money)
    result = money > 0
    add_error('Money must be greater than 0') unless result
    result
  end

  def valid_bet?(money, bet)
    result = bet <= money
    add_error('Bet must not bet greater than money') unless result
    result
  end

  def numeric?(num)
    !!Integer(num) rescue false
  end
end
