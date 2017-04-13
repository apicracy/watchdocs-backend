require 'rails_helper'

describe EndpointSerializer do
  let(:endpoint) { Fabricate(:endpoint) }
  let(:serializer) { serializer_for(endpoint) }
  subject { serialized_json(serializer) }

  it { expect(subject).to match_schema('endpoint') }
end
