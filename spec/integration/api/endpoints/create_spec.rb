# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::Endpoints::Create, type: :request do
  subject(:create_endpoint) { post '/endpoints', headers: headers, params: body, as: :json }

  let!(:api_key) { ApiKey.create!(name: 'Test Client', access_token: SecureRandom.hex(20)) }

  let(:headers) do
    { 'Authorization': "Bearer #{api_key.access_token}", 'Content-Type': 'application/json' }
  end
  let(:verb) { 'GET' }
  let(:path) { '/test' }

  let(:body_response) do
    {
      code: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: '{ "message": "Hello, world!" }'
    }
  end
  let(:body) do
    {
      data: {
        type: 'endpoints',
        attributes: {
          verb: verb,
          path: path,
          response: body_response
        }
      }
    }.to_h
  end

  context 'when the request is valid' do
    it 'creates an endpoint' do
      create_endpoint

      expect(response).to have_http_status(:created)
      parsed_response = JSON.parse(response.body).deep_symbolize_keys
      expect(parsed_response[:data][:attributes][:verb]).to eq(verb)
      expect(parsed_response[:data][:attributes][:path]).to eq(path)
      expect(parsed_response[:data][:attributes][:response][:code]).to eq(body_response[:code])
      expect(response.headers['Location']).to eq("#{request.base_url}#{body[:data][:attributes][:path]}")
    end
  end

  context 'when required parameters are missing' do
    let(:body) { {}.to_h }

    it 'returns a 400 bad request' do
      create_endpoint

      expect(response).to have_http_status(:bad_request)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to include('data is missing')
    end
  end

  context 'when an invalid verb is provided' do
    let(:verb) { 'INVALID' }

    it 'returns a 400 bad request' do
      create_endpoint

      expect(response).to have_http_status(:bad_request)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to include('data[attributes][verb] does not have a valid value')
    end
  end

  context 'when missing required nested fields' do
    let(:body_response) do
      {
        headers: { 'Content-Type' => 'application/json' },
        body: '{ "message": "Hello, world!" }'
      }
    end

    let(:body) do
      {
        data: {
          type: 'endpoints',
          attributes: {
            verb: 'GET',
            path: '/test',
            response: body_response
          }
        }
      }.to_h
    end

    it 'returns a 400 bad request for missing response fields' do
      create_endpoint

      expect(response).to have_http_status(:bad_request)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to include('data[attributes][response][code] is missing')
    end
  end
end
