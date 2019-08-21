module Api
  module V1
    module Users
      class TransactionsController < ApplicationController
        before_action :authenticate_user!
        before_action :authorize_user!

        def index
          # @transactions = User.find(params[:user_id]).transactions

          # @transactions = User.transactions_for(params[:user_id])

          @transactions = User.transactions_for(params[:user_id]).map {
            |t| t.pretty_json
          }

          render json: @transactions
        end

        def admin
          #bad way to do it apparently...
          # @transactions = Transaction.all.map {
          @transactions = Transaction.all.includes(:user).map {
            |t| t.pretty_json
          }

          render json: @transactions

        end

        def deposits
          # @deposits = User.find(params [:user_id]).transactions.where(category: "deposit")

          @deposits = User.deposits_for(params [:user_id])

          render json: @deposits

        end

        def withdrawals
          # @withdrawals = User.find(params[:user_id]).transactions.where(category: "withdrawal")
          
          @withdrawals = User.withdrawals_for(params[:user])

          render json: @withdrawals

        end

        private

        def authorize_user!
          return forbidden unless current_user.id == params[:user_id].to_i
        end
      end
    end
  end
end
