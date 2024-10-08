# frozen_string_literal: true

module API
  module Endpoints
    class Index < Grape::API
      desc 'Get all mock endpoints'
      get do
        endpoints = Endpoint.all
        present endpoints, with: ::Serializers::Endpoint, wrap_in_data: true
      end
    end
  end
end
