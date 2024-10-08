# frozen_string_literal: true
# config/initializers/grape_api.rb
Rails.application.reloader.to_prepare do
  API::Endpoints::Root
end


