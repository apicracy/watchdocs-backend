require 'rails_helper'

RSpec.describe Request, type: :model do
  subject(:request) { Fabricate.build(:request) }

  describe '#valid?' do
    it { is_expected.to allow_value(type: 'array').for(:body) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body) }
    it { is_expected.to allow_value(type: 'array').for(:body_draft) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body_draft) }
  end
end
