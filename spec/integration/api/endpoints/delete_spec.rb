# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::Endpoints::Delete, type: :request do
  subject(:delete_endpoint) { delete "/endpoints/#{endpoint_id}", headers: headers, as: :json }

  let!(:api_key) { ApiKey.create!(name: 'Test Client', access_token: SecureRandom.hex(20)) }

  let(:existing_endpoint) { create(:endpoint, verb: 'GET', path: '/old-path', response_code: 200) }
  let(:endpoint_id) { existing_endpoint.id }
  let(:headers) { { 'Authorization': "Bearer #{api_key.access_token}", 'Content-Type': 'application/json' } }

  context 'when the endpoint exists' do
    it 'deletes the endpoint and returns 204 status' do
      delete_endpoint

      expect(response).to have_http_status(:no_content)
      expect { existing_endpoint.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the endpoint does not exist' do
    let(:endpoint_id) { '999' }
    it 'returns 404 not found' do
      delete_endpoint

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Endpoint not found')
    end
  end
end
