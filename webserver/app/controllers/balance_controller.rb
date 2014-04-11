
class BalanceController < ApplicationController
  def index
  end

  def topup
    conf = YAML.load_file(Rails.root.join("config", "wallet.yml"))


    uri = URI.parse("https://#{conf["production"]["endpoint"]}/api/v2/checkout")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = {
      "payment" => {
        "amount" => params[:amount].to_f,
        "currency"=> "EUR"
      },
      "url_confirm" => "http://#{conf["production"]["hostname"]}/balance/confirm",
      "url_cancel"  => "http://#{conf["production"]["hostname"]}/balance/cancel"
    }.to_json

    request["Content-Type"] = "application/json"
    request["Authorization"] = "WalletPT #{conf["production"]["api_key"]}"

    response = http.request(request)

    jasao = JSON.parse(response.body)

    redirect_to jasao["url_redirect"]
  end

  def confirm
    render text: params.to_json
  end

  def cancel
  end
end
