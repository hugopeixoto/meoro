class Bet
  class << self
    def create(user, params)
      bet = Bet.new(params)

      ActiveRecord::Base.transaction do
        user.balance = user.balance - bet.amount
        user.save

        bet.roll = SecureRandom.random_number(100) + 1

        if (bet.low..bet.high).include?(bet.roll)
          bet.prize = bet.amount + (bet.amount * ((100.0/(bet.high-bet.low+1))-1) * (1 - 0.2))
          bet.prize = (bet.prize*100).floor / 100.0

          user.balance = (user.balance + bet.prize).round(2)
          user.save
        end
      end

      { bet: bet.attributes, user: user }
    end
  end

  attr_accessor :low, :high, :roll, :amount, :prize

  def initialize(params = {})
    @low = params.fetch(:low).to_i
    @high = params.fetch(:high).to_i
    @amount = params.fetch(:amount).to_f

    @roll = 0.0
    @prize = 0.0
  end

  def attributes
    {
      low: @low,
      high: @high,
      roll: @roll,
      amount: @amount,
      prize: @prize
    }
  end
end

