# frozen_string_literal: true

module Endpoints
  module Services
    class Delete < ::Actor
      input :id, type: Integer

      def call
        endpoint = Endpoint.find_by(id: id)
        if endpoint
          endpoint.destroy!
        else
          fail!(errors: { not_found: "Endpoint with ID #{id} not found." })
        end
      rescue ActiveRecord::RecordInvalid => e
        fail!(errors: e.record.errors.full_messages)
      end
    end
  end
end
