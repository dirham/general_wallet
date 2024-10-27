class ApplicationController < ActionController::API
  before_action :authenticate_user

  # here we use sessions to create current_user
  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    !current_user.nil?
  end

  def authenticate_user
    render json: { error: "Unauthorized" }, status: :unauthorized if current_user.nil?
  end
end
