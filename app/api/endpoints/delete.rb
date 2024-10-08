# frozen_string_literal: true

module API
  module Endpoints
    class Delete < Grape::API
      desc 'Delete a mock endpoint'
      params do
        requires :id, type: Integer
      end

      delete ':id' do
        result = ::Endpoints::Services::Delete.result(id: params[:id])
        if result.success?
          status 204
        elsif result.errors[:not_found]
          error!({ error: 'Endpoint not found' }, 404)
        else
          error!(result.errors, 422)
        end
      end
    end
  end
end
