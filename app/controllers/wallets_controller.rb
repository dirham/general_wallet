class WalletsController < ApplicationController
  def deposit
    render json: { data: @current_user }, status: :ok
  end
end
