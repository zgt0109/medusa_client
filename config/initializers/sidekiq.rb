Sidekiq.configure_client do |config|
    config.redis = {url: ENV['MEDUSA_CLIENT_REDIS_URL'],size: (Rails.env.production? ? 75 : 20)}
end
Sidekiq.configure_server do |config|
    config.redis = {url: ENV['MEDUSA_CLIENT_REDIS_URL'],size: (Rails.env.production? ? 75 : 20)}
end
