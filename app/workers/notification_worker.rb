class NotificationWorker
    include Sidekiq::Worker 

    def perform(id)
        user = User.find(id)
        NotificationService.new(ENV['WEBHOOK_SECRET_TOKEN']).notify_user_creation(user)
    end
end