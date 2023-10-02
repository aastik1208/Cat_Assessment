class NotificationService
  require 'net/http'

  def initialize(secret_token)
    @secret_token = secret_token
  end

  def notify_user_creation(user)
    message = "New user created"
    notify(user, message)
  end

  def notify_user_update(user)
    message = "User details updated"
    notify(user, message)
  end

  private

  def notify(user, message)
    api_endpoints = ENV["NOTIFY_API_ENDPOINT"].split(',')

    api_endpoints.each do |endpoint|
      payload = {
        name: user.name,
        email: user.email,
        phone_number: user.phone,
        company: user.company,
        message: message
      }

      response = send_webhook_request(endpoint, payload)
      verify_response(response)
    end
  end

  def send_webhook_request(endpoint, payload)
    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{@secret_token}"
    request.body = payload.to_json

    http.request(request)
  end

  def verify_response(response)
    if response.code.to_i == 200
      puts "Notification sent"
    else
      puts "Notification not sent"
    end
  end
end
