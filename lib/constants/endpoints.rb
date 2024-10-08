# frozen_string_literal: true

module Constants
  module Endpoints
    ENDPOINTS_TYPE = 'endpoints'
    GET = 'GET'
    POST = 'POST'
    PATCH = 'PATCH'
    DELETE = 'DELETE'

    TYPES = [ENDPOINTS_TYPE].freeze
    VERBS = [GET, POST, PATCH, DELETE].freeze

    public_constant :TYPES
    public_constant :VERBS
  end
end
