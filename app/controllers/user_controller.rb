class UserController < ApplicationController
  before_action :get_user, only: [:update]

  def create
    @user = User.new(user_params)
    if @user.save
      NotificationService.new(ENV['WEBHOOK_SECRET_TOKEN']).notify_user_creation(@user)
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      NotificationService.new(ENV['WEBHOOK_SECRET_TOKEN']).notify_user_update(@user)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone)
  end
end
