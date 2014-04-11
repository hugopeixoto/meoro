class ApplicationController < ActionController::Base
  # protect_from_forgery with: :null_session

  protected

  def current_user
    @user ||= User.where(token: session[:auth_token]).first
  end
end

