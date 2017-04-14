require 'rails_helper'

describe EndpointSerializer do
  let(:endpoint) { Fabricate(:endpoint) }
  let(:serializer) { serializer_for(endpoint) }
  subject { serialized_json(serializer) }

  context 'when endpoint does not have associations' do
    it { expect(subject).to match_schema('endpoint') }
  end

  context 'when endpoint have all associations' do
    before do
      Fabricate(:request, endpoint: endpoint)
      Fabricate(:response, endpoint: endpoint)
      Fabricate(:url_param, endpoint: endpoint)
    end

    it { expect(subject).to match_schema('endpoint') }
  end
end
