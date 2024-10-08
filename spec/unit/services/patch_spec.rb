# frozen_string_literal: true

require 'rails_helper'

describe Endpoints::Services::Patch, type: :service do
  let(:verb) { 'POST' }
  let(:path) { '/updated/path' }
  let(:response) do
    {
      code: 201,
      headers: { 'Content-Type' => 'application/json' },
      body: '{ "message": "Updated!" }'
    }
  end

  let(:existing_endpoint) { create(:endpoint, verb: 'GET', path: '/old/path', response_code: 200) }

  subject(:service_call) do
    described_class.result(
      id: existing_endpoint.id,
      verb: verb,
      path: path,
      response: response
    )
  end

  context 'when the update is successful' do
    before do
      allow_any_instance_of(Services::Schemas::Endpoints::Patch)
        .to receive(:call)
        .and_return(double(success?: true)) # Mock successful schema validation
    end

    it 'updates the endpoint successfully' do
      expect(service_call).to be_success
      expect(service_call.endpoint.verb).to eq('POST')
      expect(service_call.endpoint.path).to eq('/updated/path')
      expect(service_call.endpoint.response_code).to eq(201)
      expect(service_call.endpoint.response_body).to eq('{ "message": "Updated!" }')
    end
  end

  context 'when the schema validation fails' do
    before do
      allow_any_instance_of(Services::Schemas::Endpoints::Patch)
        .to receive(:call)
        .and_return(double(success?: false,
                           errors: { response_code: ['must be a valid HTTP status code'] }))
    end

    it 'fails with schema validation errors' do
      expect(service_call).to be_failure
      expect(service_call.errors).to include(response_code: ['must be a valid HTTP status code'])
    end
  end

  context 'when the endpoint is not found' do
    let(:invalid_id) { 999 }

    subject(:invalid_service_call) do
      described_class.result(
        id: invalid_id,
        verb: verb,
        path: path,
        response: response
      )
    end

    it 'fails with an endpoint not found error' do
      expect(invalid_service_call).to be_failure
      expect(invalid_service_call.errors).to eq("Endpoint with ID #{invalid_id} not found.")
    end
  end

  context 'when the update fails due to invalid data' do
    let(:invalid_verb) { 'INVALID_VERB' }

    subject(:invalid_service_call) do
      described_class.result(
        id: existing_endpoint.id,
        verb: invalid_verb,
        path: path,
        response: response
      )
    end

    it 'fails with validation errors' do
      expect(invalid_service_call).to be_failure
      expect(invalid_service_call.errors).to include(verb: ['must be one of: GET, POST, PATCH, DELETE'])
    end
  end
end
