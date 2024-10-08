# config/initializers/lograge.rb
Rails.application.configure do
  config.lograge.enabled = true

  # Use a single line format for logs
  # config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.formatter = Lograge::Formatters::Logstash.new # Use Logstash format if required

  # Add custom fields to logs
  config.lograge.custom_options = lambda do |event|
    {
      time: event.time,
      host: Socket.gethostname,
      user_id: event.payload[:user_id], # Example of adding user_id if available
      api_key: event.payload[:api_key], # Example of adding api_key if available
      params: event.payload[:params].except("controller", "action", "format", "id") # Log params except default Rails params
    }
  end

  # Suppress logging of assets and other noise
  config.lograge.ignore_actions = ['ActiveStorage::DiskController#show']
end
