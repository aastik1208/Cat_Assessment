class UserController < ApplicationController
  require 'net/http'
  before_action :get_user, only: [:update]

  def create
    @user = User.new(user_params)
    if @user.save
      notify_change_api(@user)
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
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

  def notify_change_api(user)
    api_endpoints = ENV["NOTIFY_API_ENDPOINT"].split(',')

    api_endpoints.each do |endpoint|
      payload = {
        name: user.name,
        email: user.email,
        phone_number: user.phone
      }

      response = send_webhook_request(endpoint, payload)
      verify_response(response)
    end
    end
  end

  def send_webhook_request(endpoint, payload)
    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)

    secret_token = ENV['WEBHOOK_SECRET_TOKEN']

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{secret_token}"
    request.body = payload.to_json

    http.request(request)
  end

  def verify_response(response)
    if response.code.to_i == 200
      puts "verified"
    else
      puts "verification failed"
    end
  end
end
