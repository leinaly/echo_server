# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

require 'securerandom'

# Clear existing records
ApiKey.destroy_all
Endpoint.destroy_all

# Seed some API keys
api_keys = [
  { name: 'Test Client 1', access_token: SecureRandom.hex(20) },
  { name: 'Test Client 2', access_token: SecureRandom.hex(20) }
]

api_keys.each do |api_key|
  ApiKey.create!(api_key)
end

puts "Created #{ApiKey.count} API keys."

# Seed some Endpoints
endpoints = [
  {
    verb: 'GET',
    path: '/hello',
    response_code: 200,
    response_headers: { 'Content-Type' => 'application/json' },
    response_body: '{ "message": "Hello, world!" }'
  },
  {
    verb: 'POST',
    path: '/submit',
    response_code: 201,
    response_headers: { 'Content-Type' => 'application/json' },
    response_body: '{ "message": "Data submitted successfully!" }'
  },
  {
    verb: 'PATCH',
    path: '/update_test',
    response_code: 200,
    response_headers: { 'Content-Type' => 'application/json' },
    response_body: '{ "message": "Data updated successfully!" }'
  },
  {
    verb: 'DELETE',
    path: '/delete_test',
    response_code: 204,
    response_headers: {},
    response_body: ''
  }
]

endpoints.each do |endpoint|
  Endpoint.create!(endpoint)
end

puts "Created #{Endpoint.count} endpoints."
