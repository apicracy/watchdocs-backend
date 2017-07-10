require 'rails_helper'

RSpec.describe Projects::FetchEndpoint do
  let(:service) { described_class.new(endpoint_id) }
  let(:endpoint_id) { endpoint.id }
  let(:endpoint) { Fabricate(:endpoint) }

  describe 'when passing valid parameters' do
    it 'returns relevant endpoint' do
      returned_endpoint = service.call
      expect(returned_endpoint.id).to be endpoint.id
    end
  end

  describe 'when passing invalid params' do
    let(:endpoint_id) { endpoint.id + 1 }

    it 'raises ActiveRecord::RecordNotFound exception' do
      expect { service.call }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
