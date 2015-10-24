module Blackjack
  INVALID_MONEY = -1
  def set_player_name(name)
    if name.empty?
      add_error('No name given')
    else
      session[:player_name] = name
    end
  end

  def player_name
    session[:player_name]
  end

  def buy_in(money)
    money = numeric?(money) ? Integer(money) : INVALID_MONEY
    session[:buy_in] = money if valid_input?(money) && valid_value?(money)
  end

  def money
    session[:buy_in]
  end

  private

  def valid_value?(money)
    result = money.modulo(10) == 0
    add_error('Money must be a multiple of 10') unless result
    result
  end

  def valid_input?(money)
    result = money > 0
    add_error('Money must be greater than 0') unless result
    result
  end

  def numeric?(num)
    !!Integer(num) rescue false
  end
end
