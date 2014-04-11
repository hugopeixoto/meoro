class WelcomeController < ApplicationController
  def index
    @user = current_user

    if(@user.nil?)
      @user = User.create(name: "default")
      session[:auth_token] = @user.token
    end
  end
end
