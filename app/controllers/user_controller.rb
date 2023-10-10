class UserController < ApplicationController
  before_action :get_user, only: [:update]

  def create
    @user = User.new(user_params)
    if @user.save
      NotificationWorker.perform_async(@user.id)
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      NotificationWorker.perform_async(@user.id)
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
