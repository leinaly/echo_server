# frozen_string_literal: true
# config/initializers/load_api.rb

# Require all files in the app/api directory
Dir[Rails.root.join('app/api/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('app/api/serializers/*.rb')].each { |f| require f }
Dir[Rails.root.join('app/services/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('app/steps/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('lib/**/*.rb')].each { |f| require f }



