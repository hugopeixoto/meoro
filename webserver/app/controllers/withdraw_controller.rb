require 'net/http'
require 'uri'

class WithdrawController < ApplicationController
  def index
  end

  def cash_out
    a = User.where(token: session[:auth_token]).first

    redirect_to :root and return if !a

    uri = URI.parse("https://#{ENV["PRODUCTION_ENDPOINT"]}/api/v2/users/#{URI.escape(params[:email])}/transfer")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = {
      "amount" => a.balance.to_f,
      "method"=> "WALLET"
    }.to_json

    request["Content-Type"] = "application/json"
    request["Authorization"] = "WalletPT #{ENV["PRODUCTION_API_KEY"]}"

    response = http.request(request)

    jasao = JSON.parse(response.body)

    if jasao["status"] == "COMPLETED"
      a.update_attributes(amount: 0.0)
      redirect_to :root, notice: "Transfer successful. Don't forget to top up!"
    else
      redirect_to '/withdraw', flash: {
        error: "Email non-existent, please provide your MEO wallet email address" }
    end
  end
end
