# frozen_string_literal: true

require 'grape'

module API
  module Endpoints
    class Root < Grape::API
      format :json

      # TODO: move to separate service
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
        authenticate! unless request.path == '/status'
      end

      resource :endpoints do
        mount Create
        mount Index
        mount Delete
        mount Patch
      end

      # Test endpoint
      get :status do
        { status: 'OK' }
      end

      # TODO: need to add separate service and add rspecs
      # TODO: don't allow in create to create endpoints which already declared in routes
      route :any, '*path' do
        path = "/#{params[:path]}"
        verb = request.request_method.upcase
        endpoint = Endpoint.find_by(path: path, verb: verb)

        if endpoint
          status endpoint.response_code
          header 'Content-Type', endpoint.response_headers['Content-Type']
          body JSON.parse(endpoint.response_body)
        else
          error!(
            { errors: [{ code: 'not_found',
                         detail: "Requested page #{path} does not exist" }] }, 404
          )
        end
      end
    end
  end
end
