# frozen_string_literal: true

module Endpoints
  module Services
    class Create < ::Actor
      input :verb, type: String
      input :path, type: String
      input :response, type: Hash

      output :endpoint

      def call
        validate_schema
        validate_ep_already_exist

        self.endpoint = ::Endpoint.create!(
          verb: verb,
          path: path,
          response_code: response[:code],
          response_headers: response[:headers],
          response_body: response[:body]
        )
      rescue ActiveRecord::RecordInvalid => e
        fail!(errors: e.record.errors.full_messages)
      end

      private

      def schema
        @schema ||= ::Services::Schemas::Endpoints::Create.new.call(response)
      end

      def validate_schema
        return if schema.success?

        fail!(
          error: 'Attributes in response are not valid',
          code: :bad_request,
          errors: schema.errors.to_hash
        )
      end

      def validate_ep_already_exist
        return unless Endpoint.exists?(['UPPER(verb) = ? AND LOWER(path) = ?', verb.upcase,
                                        path.downcase])

        fail!(
          error: "Endpoint with path: #{path}, verb: #{verb} already exists",
          code: :bad_request
        )
      end
    end
  end
end
