class WalletsController < ApplicationController
  include ErrorHandler

  def balance
    render json: { data: @current_user.wallet.balance.to_f }, status: :ok
  end
  def deposit
    # simulate deposit (always success to add balance to wallet)
    handle_errors do
      @current_user.wallet.deposit(params[:amount])
      render json: { data: "success" }, status: :ok
    end
  end

  def transfer
    handle_errors do
      target_wallet = User.find(params[:user_id])
      @current_user.wallet.transfer(target_wallet.wallet, params[:amount].to_d)
      render json: { data: "success" }, status: :ok
    end
  end

  def withdrawal
    handle_errors do
      @current_user.wallet.withdraw(params[:amount].to_d)
      render json: { data: "success" }, status: :ok
    end
  end
end
