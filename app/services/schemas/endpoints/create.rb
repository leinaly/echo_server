# frozen_string_literal: true

module Services
  module Schemas
    module Endpoints
      class Create < Dry::Validation::Contract
        params do
          required(:code).value(:integer)
          required(:headers).value(:hash)
          required(:body).value(:string)
        end

        rule('code') do
          key.failure('must be a valid HTTP status code (100-599)') unless value.is_a?(Integer) && value.between?(
            100, 599
          )
        end

        rule('body') do
          JSON.parse(value)
        rescue JSON::ParserError
          key.failure('must be a valid JSON string')
        end
      end
    end
  end
end
