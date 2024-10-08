# frozen_string_literal: true

# spec/factories/endpoints.rb
FactoryBot.define do
  factory :endpoint do
    verb { 'GET' }
    path { '/test' }
    response_code { 200 }
    response_headers { { 'Content-Type' => 'application/json' } }
    response_body { '{ "message": "Hello, world!" }' }
  end
end
