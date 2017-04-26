require 'rails_helper'

RSpec.describe EndpointSerializer, type: :serializer do
  let(:endpoint) { Fabricate(:endpoint) }
  let(:serializer) { serializer_for(endpoint) }
  subject { serialized_json(serializer) }

  context 'when endpoint does not have associations' do
    it { is_expected.to match_schema('endpoint') }
  end

  context 'when endpoint have all associations' do
    before do
      Fabricate(:request, endpoint: endpoint)
      Fabricate(:response, endpoint: endpoint)
      Fabricate(:url_param, endpoint: endpoint)
    end

    it { is_expected.to match_schema('endpoint') }
  end

  context 'when endpoint has many responses' do
    before do
      Fabricate(:response, endpoint: endpoint, http_status_code: 400)
      Fabricate(:response, endpoint: endpoint, http_status_code: 404)
      Fabricate(:response, endpoint: endpoint, http_status_code: 200)
    end

    it 'sorts them by http status code' do
      responses = serializer.to_h[:responses]
      expect(responses.map { |resp| resp[:http_status_code] }).to eq [200, 400, 404]
    end
  end
end
