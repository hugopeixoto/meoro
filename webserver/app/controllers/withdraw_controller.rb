require 'net/http'
require 'uri'

class WithdrawController < ApplicationController
  def index
  end

  def cash_out
    redirect_to :root and return if !Bet::TOP_UP_AMOUNTS.include?(params[:amount].to_i)
    user = User.where(token: session[:auth_token]).first

    redirect_to :root and return if !user

    uri = URI.parse("https://#{ENV["PRODUCTION_ENDPOINT"]}/api/v2/users/#{URI.escape(params[:email])}/transfer")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    real_value = params[:amount].to_f >= user.balance ? user.balance : params[:amount].to_f

    request.body = {
      "amount" => real_value,
      "method"=> "WALLET"
    }.to_json

    request["Content-Type"] = "application/json"
    request["Authorization"] = "WalletPT #{ENV["PRODUCTION_API_KEY"]}"

    response = http.request(request)

    begin
      jasao = JSON.parse(response.body)

      if jasao["status"] == "COMPLETED"
        user.balance -= real_value
        user.save
        flash[:notice] = "Transfer successful. Do not forget to top up!"
      else
        flash[:error] = jasao["message"]
      end
    rescue
      flash[:error] = "Oops."
    end
  end
end
