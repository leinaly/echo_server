# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::Endpoints::Patch, type: :request do
  let(:existing_endpoint) { create(:endpoint, verb: 'GET', path: '/old-path', response_code: 200) }

  let!(:api_key) { ApiKey.create!(name: 'Test Client', access_token: SecureRandom.hex(20)) }

  let(:headers) do
    { 'Authorization': "Bearer #{api_key.access_token}", 'Content-Type': 'application/json' }
  end

  let(:update_params) do
    {
      data: {
        id: existing_endpoint.id,
        type: 'endpoints',
        attributes: {
          verb: 'POST',
          path: '/new-path',
          response: {
            code: 201,
            headers: { 'Content-Type' => 'application/json' },
            body: '{ "message": "Updated!" }'
          }
        }
      }
    }.to_h
  end

  subject(:update_request) do
    patch "/endpoints/#{existing_endpoint.id}", params: update_params, headers: headers, as: :json
  end

  context 'when the update is successful' do
    it 'updates the endpoint and returns the updated endpoint with location header' do
      update_request

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body).deep_symbolize_keys
      expect(parsed_response[:data][:attributes][:verb]).to eq('POST')
      expect(parsed_response[:data][:attributes][:path]).to eq('/new-path')
      expect(parsed_response[:data][:attributes][:response][:code]).to eq(201)

      # Check the Location header
      expect(response.headers['Location']).to eq("#{request.base_url}/new-path")
    end
  end

  context 'when the endpoint is not found' do
    let(:invalid_id) { '999' }
    let(:update_params) do
      {
        data: {
          id: invalid_id,
          type: 'endpoints',
          attributes: {
            verb: 'POST',
            path: '/new-path',
            response: {
              code: 201,
              headers: { 'Content-Type' => 'application/json' },
              body: '{ "message": "Updated!" }'
            }
          }
        }
      }.to_h
    end

    subject(:invalid_update_request) do
      patch "/endpoints/#{invalid_id}", params: update_params, headers: headers, as: :json
    end

    it 'returns a 404 not found error' do
      invalid_update_request

      expect(response).to have_http_status(:not_found)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to include('Endpoint with ID 999 not found.')
    end
  end

  context 'when there are validation errors' do
    let(:invalid_update_params) do
      {
        data: {
          id: 12,
          type: 'endpoints',
          attributes: {
            verb: 'INVALID_VERB',
            path: '/new-path',
            response: {
              code: 201,
              headers: { 'Content-Type' => 'application/json' },
              body: '{ "message": "Updated!" }'
            }
          }
        }
      }.to_h
    end

    subject(:invalid_request) do
      patch "/endpoints/#{existing_endpoint.id}", params: invalid_update_params,
                                                  headers: headers, as: :json
    end

    it 'fails with validation errors for invalid verb' do
      invalid_request

      expect(response).to have_http_status(:bad_request)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to include('data[attributes][verb] does not have a valid value')
    end
  end

  context 'when the response body is invalid JSON' do
    let(:invalid_update_params) do
      {
        data: {
          id: 12,
          type: 'endpoints',
          attributes: {
            verb: 'POST',
            path: '/new-path',
            response: {
              code: 201,
              headers: { 'Content-Type' => 'application/json' },
              body: 'Invalid JSON'
            }
          }
        }
      }.to_h
    end

    subject(:invalid_request) do
      patch "/endpoints/#{existing_endpoint.id}", params: invalid_update_params,
                                                  headers: headers, as: :json
    end

    it 'fails with validation errors for invalid JSON body' do
      invalid_request

      expect(response).to have_http_status(:bad_request)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['response']['body'].first).to include('must be a valid JSON string')
    end
  end

  context 'when required parameters are missing' do
    let(:invalid_update_params) { {}.to_h }

    subject(:invalid_request) do
      patch "/endpoints/#{existing_endpoint.id}", params: invalid_update_params,
                                                  headers: headers, as: :json
    end

    it 'returns a 400 bad request for missing required parameters' do
      invalid_request

      expect(response).to have_http_status(:bad_request)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to include('data is missing')
    end
  end
end
