module Blackjack
  def buy_in(money)
    Integer(money) if valid_money_input?(money) && valid_denomination?(money)
  end

  private

  def valid_denomination?(money)
    Integer(money).modulo(10) == 0
  end

  def valid_money_input?(money)
    @error = 'Wrong money input'
    numeric?(money) && Integer(money) > 0
  end

  def numeric?(num)
    !!Integer(num) rescue false
  end
end
