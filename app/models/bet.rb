class Bet < ActiveRecord::Base

  class << self
    def create(user, params)
      bet = Bet.new(params)

      ActiveRecord::Base.transaction do
        amount = params[:amount]
        low = params[:low]
        high = params[:high]

        user.balance = user.balance - params[:amount]
        user.save

        roll = Random.rand(100) + 1

        if (low..high).include?(roll)
          prize = amount * (100/(high-low)) * (1 - 0.1)

          user.balance = user.balance + prize
          user.save
        end

        bet.roll = roll
        bet.user = user

        bet.save
      end
    end
  end

  belongs_to :user
end

