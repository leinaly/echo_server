# frozen_string_literal: true

# TODO: rename to Update after adding filtering rules for creation for path & updating seeds
module API
  module Endpoints
    class Patch < Grape::API
      desc 'Update a mock endpoint'
      params do
        requires :data, type: Hash do
          requires :id, type: Integer
          requires :type, type: String, values: Constants::Endpoints::TYPES
          requires :attributes, type: Hash do
            optional :verb, type: String, values: Constants::Endpoints::VERBS
            optional :path, type: String
            optional :response, type: Hash do
              optional :code, type: Integer
              optional :headers, type: Hash
              optional :body, type: String
            end
          end
        end
      end

      patch ':id' do
        result = ::Endpoints::Services::Patch.result(id: params[:data][:id],
                                                     verb: params[:data][:attributes][:verb],
                                                     path: params[:data][:attributes][:path],
                                                     response: params[:data][:attributes][:response])
        if result.success?
          header 'Location', "#{request.base_url}#{result.endpoint.path}"

          present result.endpoint, with: ::Serializers::Endpoint, wrap_in_data: true
        else
          error!(result.errors, result.code)
        end
      end
    end
  end
end
