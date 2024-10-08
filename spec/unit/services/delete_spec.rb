# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoints::Services::Delete, type: :service do
  subject(:service_call) { described_class.result(id: endpoint_id) }

  let!(:existing_endpoint) { create(:endpoint, verb: 'GET', path: '/existing-path', response_code: 200) }
  let(:endpoint_id) { existing_endpoint.id }

  describe '#call' do
    context 'when the endpoint exists' do
      it 'deletes the endpoint successfully' do
        expect { service_call }.to change { Endpoint.count }.by(-1)
        expect(service_call).to be_success
      end
    end

    context 'when the endpoint does not exist' do
      let(:endpoint_id) { -1 } # Non-existent ID

      it 'fails with a not_found error' do
        expect(service_call).to be_failure
        expect(service_call.errors[:not_found]).to eq('Endpoint with ID -1 not found.')
      end
    end
  end
end
