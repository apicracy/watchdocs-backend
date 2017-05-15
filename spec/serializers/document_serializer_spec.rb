require 'rails_helper'

RSpec.describe DocumentSerializer, type: :serializer do
  let(:document) { Fabricate(:document) }
  let(:serializer) { serializer_for(document) }
  subject { serialized_json(serializer) }

  it { is_expected.to match_schema('document') }
end
