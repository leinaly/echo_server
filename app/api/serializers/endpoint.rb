# frozen_string_literal: true

module Serializers
  class Endpoint < Grape::Entity
    def self.represent(object, options = {})
      if options[:wrap_in_data]
        super(object, options.merge(root: 'data'))
      else
        super(object, options)
      end
    end

    expose :type do |_endpoint, _options|
      'endpoints'
    end

    expose :id

    expose :attributes do
      expose :verb
      expose :path

      expose :response do
        expose :response_code, as: :code
        expose :response_headers, as: :headers
        expose :response_body, as: :body
      end
    end

    expose :id, if: ->(_endpoint, options) { options[:new_record] == false }
  end
end
