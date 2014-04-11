module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json

      def show
        respond_with User.where(token: params[:id]).first
      end

      def update
        @user = User.where(token: params[:id]).first
        respond_with @user.update_attributes(params.require(:user).permit(:name))
      end
    end
  end
end

