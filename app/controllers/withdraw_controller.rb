require 'net/http'
require 'uri'

class BalanceController < ApplicationController
  def index
  end

  def cash_out
    a = User.where(token: token).first

    uri = URI.parse("https://#{ENV["PRODUCTION_ENDPOINT"]}/api/v2/checkout")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = {
      "payment" => {
        "amount" => a.balance.to_f,
        "currency"=> "EUR",
        "ext_customerid" => session[:auth_token],
        "type" => "USERTRANSFER",
        "client" => {
          "email" => params[:email]
        }
      },
      "url_confirm" => "http://#{ENV["PRODUCTION_HOSTNAME"]}/withdraw/confirm",
      "url_cancel"  => "http://#{ENV["PRODUCTION_HOSTNAME"]}/withdraw/cancel"
    }.to_json

    request["Content-Type"] = "application/json"
    request["Authorization"] = "WalletPT #{ENV["PRODUCTION_API_KEY"]}"

    response = http.request(request)

    jasao = JSON.parse(response.body)

    redirect_to jasao["url_redirect"]
  end

  def confirm
    uri = URI.parse("https://#{ENV['PRODUCTION_ENDPOINT']}/api/v2/checkout/#{params["checkoutid"]}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    request["Content-Type"] = "application/json"
    request["Authorization"] = "WalletPT #{ENV["PRODUCTION_API_KEY"]}"

    response = http.request(request)

    jasao = JSON.parse(response.body)

    amount = jasao["payment"]["amount"]
    token  = jasao["payment"]["ext_customerid"]

    a = User.where(token: token).first
    a.balance -= amount
    a.save

    redirect_to :root
  end

  def cancel
  end
end
