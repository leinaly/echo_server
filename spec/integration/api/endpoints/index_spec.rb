# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::Endpoints::Index, type: :request do
  subject(:get_endpoints) { get '/endpoints', headers: headers }

  let!(:api_key) { ApiKey.create!(name: 'Test Client', access_token: SecureRandom.hex(20)) }

  let(:headers) do
    { 'Authorization': "Bearer #{api_key.access_token}", 'Content-Type': 'application/json' }
  end

  context 'when there are endpoints' do
    let!(:endpoint1) { create(:endpoint, verb: 'GET', path: '/test1', response_code: 200) }
    let!(:endpoint2) { create(:endpoint, verb: 'POST', path: '/test2', response_code: 201) }

    it 'returns all endpoints' do
      get_endpoints

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body).deep_symbolize_keys

      expect(parsed_response[:data].size).to eq(2)
      expect(parsed_response[:data].first[:attributes][:verb]).to eq('GET')
      expect(parsed_response[:data].first[:attributes][:path]).to eq('/test1')
      expect(parsed_response[:data].last[:attributes][:verb]).to eq('POST')
      expect(parsed_response[:data].last[:attributes][:path]).to eq('/test2')
    end
  end

  context 'when there are no endpoints' do
    it 'returns an empty array' do
      get_endpoints

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body).deep_symbolize_keys

      expect(parsed_response[:data]).to eq([])
    end
  end
end
