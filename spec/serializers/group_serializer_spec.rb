require 'rails_helper'

RSpec.describe GroupSerializer, type: :serializer do
  let(:group) { Fabricate(:group) }
  let(:serializer) { serializer_for(group) }
  subject { serialized_json(serializer) }

  it { is_expected.to match_schema('group') }
end
