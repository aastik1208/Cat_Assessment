class NotificationWorker
    include Sidekiq::Worker 

    def perform(id, action)
        user = User.find(id)
        if action == :create
            NotificationService.new(ENV['WEBHOOK_SECRET_TOKEN']).notify_user_creation(user)
        else
            NotificationService.new(ENV['WEBHOOK_SECRET_TOKEN']).notify_user_update(user)
        end
    end
end