# frozen_string_literal: true

# TODO: Handle validation if an endpoint with the same verb and path already exists after the update.
module Endpoints
  module Services
    class Patch < ::Actor
      input :id, type: Integer
      input :verb, type: String
      input :path, type: String
      input :response, type: Hash

      output :endpoint

      def call
        validate_schema
        find_endpoint
        update_endpoint
      end

      private

      def validate_schema
        return if schema.success?

        fail!(
          error: 'Attributes in response are not valid',
          code: :bad_request,
          errors: schema.errors.to_hash
        )
      end

      def find_endpoint
        self.endpoint = ::Endpoint.find(id)
      rescue ActiveRecord::RecordNotFound
        fail!(errors: "Endpoint with ID #{id} not found.", code: :not_found)
      end

      def update_endpoint
        endpoint.with_lock do
          endpoint.update!(
            verb: verb,
            path: path,
            response_code: response[:code],
            response_headers: response[:headers],
            response_body: response[:body]
          )
        end
      rescue ActiveRecord::RecordInvalid => e
        fail!(errors: e.record.errors.full_messages)
      end

      def schema
        @schema ||= ::Services::Schemas::Endpoints::Patch.new.call({
                                                                     id: id,
                                                                     verb: verb,
                                                                     path: path,
                                                                     response: response
                                                                   })
      end
    end
  end
end
