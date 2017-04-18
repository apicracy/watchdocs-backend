require 'rails_helper'

RSpec.describe ResponseSerializer, type: :serializer do
  let(:response) { Fabricate(:response) }
  let(:serializer) { serializer_for(response) }
  subject { serialized_json(serializer) }

  it { is_expected.to match_schema('response') }
end
