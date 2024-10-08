# frozen_string_literal: true

module Services
  module Schemas
    module Endpoints
      class Patch < Dry::Validation::Contract
        params do
          required(:id).value(:integer)
          optional(:verb).filled(included_in?: Constants::Endpoints::VERBS)
          optional(:path).value(:string)
          optional(:response).hash do
            optional(:code).value(:integer)
            optional(:headers).value(:hash)
            optional(:body).value(:string)
          end
        end

        rule(:path) do
          next unless key? && value.present?

          key.failure('must start with a forward slash (/)') unless value&.start_with?('/')
        end

        rule('response.code') do
          next unless key? && value.present?

          key.failure('must be a valid HTTP status code (100-599)') unless value.is_a?(Integer) && value.between?(
            100, 599
          )
        end

        rule('response.headers') do
          next unless key? && value.present?

          err_msg = 'must have string keys and string values, but found'

          if value.is_a?(Hash)
            value.each do |header_key, header_value|
              unless header_key.is_a?(String) && header_value.is_a?(String)
                key.failure("#{err_msg} #{header_key.class} => #{header_value.class}")
              end
            end
          else
            key.failure('must be a hash of string key-value pairs')
          end
        end

        rule('response.body') do
          next unless key? && value.present?

          begin
            JSON.parse(value)
          rescue JSON::ParserError
            key.failure('must be a valid JSON string')
          end
        end
      end
    end
  end
end
