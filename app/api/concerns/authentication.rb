# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helpers do
      def authenticate!
        error!('Unauthorized. Invalid or missing API key.', 401) unless valid_api_key?
      end

      def valid_api_key?
        token = headers['Authorization']&.split(' ')&.last
        @api_key = ApiKey.find_by(access_token: token)
      end

      def current_api_key
        @api_key
      end
    end

    before do
      authenticate!
    end
  end
end
