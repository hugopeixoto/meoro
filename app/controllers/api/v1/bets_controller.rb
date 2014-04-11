module Api
  module V1
    class BetsController < ApplicationController
      respond_to :json

      def index
        respond_with Bet.all
      end

      def show
        respond_with Bet.find(params[:id])
      end

      def create
        respond_with Bet.create(current_user, params.require(:bet).parmit([:amount, :high, :low]))
      end
    end
  end
end

