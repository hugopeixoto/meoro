class User < ActiveRecord::Base

  class << self
    def create(params)
      user = User.new(params)
      user.balance = 1
      user.token = SecureRandom.hex(20)

      if(user.save)
        return user
      else
        raise
      end
    end
  end

end
