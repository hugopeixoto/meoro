module Api
  module V1
    class BetsController < ApplicationController
      respond_to :json

      def create
        if(params.has_key?(:bet))
          amount = params[:bet][:amount].to_f || 1000000.0

          if([1,2,5].include?(amount))
            final_balance = current_user.balance - amount

            if(final_balance >= 0)
              render json: Bet.create(current_user, params.require(:bet).permit([:amount, :high, :low]))
            else
              head :payment_required
            end
          else
            head :bad_request
          end
        else
          head :bad_request
        end
      end
    end
  end
end

