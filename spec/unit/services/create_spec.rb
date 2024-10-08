# frozen_string_literal: true

require 'rails_helper'

describe Endpoints::Services::Create, type: :service do
  let(:verb) { 'GET' }
  let(:path) { '/test/endpoint' }
  let(:response) do
    { code: 200, headers: { 'Content-Type' => 'application/json' },
      body: '{ "message": "Hello, world!" }' }
  end

  subject(:service_call) { described_class.result(verb: verb, path: path, response: response) }

  context 'when schema validation succeeds' do
    it 'creates an endpoint successfully' do
      allow_any_instance_of(Services::Schemas::Endpoints::Create)
        .to receive(:call)
        .and_return(double(success?: true))

      expect { service_call }.to change(Endpoint, :count).by(1)
      expect(service_call.endpoint.verb).to eq('GET')
      expect(service_call.endpoint.path).to eq('/test/endpoint')
    end
  end

  context 'when schema validation fails' do
    let(:invalid_response) do
      {
        code: 'invalid', # Invalid code, should be an integer
        headers: { 'Content-Type' => 'application/json' },
        body: '{ "message": "Hello, world!" }'
      }
    end

    subject(:invalid_service_call) do
      described_class.result(verb: verb, path: path, response: invalid_response)
    end

    it 'fails with schema validation errors' do
      allow_any_instance_of(Services::Schemas::Endpoints::Create)
        .to receive(:call)
        .and_return(double(success?: false,
                           errors: { response_code: ['must be an integer'] }))

      expect(invalid_service_call).to be_failure
      expect(invalid_service_call.errors).to include(response_code: ['must be an integer'])
    end
  end

  context 'when the endpoint already exists' do
    before do
      Endpoint.create!(verb: verb, path: path.downcase, response_code: 200, response_headers: {},
                       response_body: '{ "message": "Hello, world!" }')
    end

    it 'fails with endpoint already exists error' do
      allow_any_instance_of(Services::Schemas::Endpoints::Create)
        .to receive(:call)
        .and_return(double(success?: true))

      expect(service_call).to be_failure
      expect(service_call.error).to eq("Endpoint with path: #{path}, verb: #{verb} already exists")
    end
  end

  context 'when the endpoint does not exist yet' do
    it 'creates the endpoint successfully' do
      allow_any_instance_of(Services::Schemas::Endpoints::Create)
        .to receive(:call)
        .and_return(double(success?: true))

      expect { service_call }.to change(Endpoint, :count).by(1)
      expect(service_call).to be_success
    end
  end
end
