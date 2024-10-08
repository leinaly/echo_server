# frozen_string_literal: true

module API
  module Endpoints
    class Create < Grape::API
      desc 'Create a mock endpoint'
      params do
        requires :data, type: Hash do
          requires :type, type: String, values: Constants::Endpoints::TYPES
          requires :attributes, type: Hash do
            requires :verb, type: String, values: Constants::Endpoints::VERBS
            requires :path, type: String
            requires :response, type: Hash do
              requires :code, type: Integer
              requires :headers, type: Hash
              requires :body, type: String
            end
          end
        end
      end

      post do
        result = ::Endpoints::Services::Create.result(params[:data][:attributes])
        if result.success?
          header 'Location', "#{request.base_url}#{result.endpoint.path}"

          present result.endpoint, with: ::Serializers::Endpoint, new_record: true,
                                   wrap_in_data: true
        else
          error!(result.errors, 422)
        end
      end
    end
  end
end
