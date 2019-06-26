module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: [:create]
      before_action :authorize_user!, only: [:update, :transfer]

      def index
        @users = User.all

        render json: @users
      end

      def show
        @user = User.find(params[:id])

        render json: @user
      end

      def create
        @user = User.new(user_params)
        @user.save!
        render json: @user
      end

      def update
        @user = User.find(params[:id])
        @user.update!(user_params)
        render json: @user
      end

      def transfer
        @sender = User.find(params[:id])
        @receiver = User.find_by!(email: transfer_params[:email])

        @withdrawal = TransferService.new(@sender, @receiver, transfer_params[:amount]).process!

        render json: @withdrawal
      rescue TransferService::TransferError => e
        render json: { error: "Transfer Error", message: e.message }, status: :unprocessable_entity
      end

      private

      def authorize_user!
        return forbidden unless current_user.id == params[:id].to_i
      end

      def transfer_params
        params.permit(:amount, :email)
      end

      def user_params
        params.permit(:name, :email, :balance)
      end
    end
  end
end
