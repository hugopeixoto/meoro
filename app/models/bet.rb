class Bet < ActiveRecord::Base

  class << self
    def create(user, params)
      bet = Bet.new(params)

      amount = params[:amount].to_f
      low = params[:low].to_i
      high = params[:high].to_i

      prize = 0
      roll = 0

      ActiveRecord::Base.transaction do
        user.balance = user.balance - amount
        user.save

        roll = Random.rand(100) + 1

        if (low..high).include?(roll)
          prize = amount + (amount * ((100.0/(high-low+1))-1) * (1 - 0.2))

          user.balance = user.balance + prize
          user.save
        end

        bet.roll = roll
        bet.user = user

        bet.save
      end

      {
        bet: bet.attributes.merge({prize: prize, roll: roll}), 
        user: {name: user.name, balance: user.balance}}
    end
  end

  belongs_to :user
end

