require 'rails_helper'

RSpec.describe Response, type: :model do
  subject(:response) { Fabricate.build(:response) }

  describe '#valid?' do
    it { is_expected.to allow_value(type: 'array').for(:body) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body) }
    it { is_expected.to allow_value(type: 'array').for(:body_draft) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body_draft) }
    it { is_expected.to validate_uniqueness_of(:http_status_code).scoped_to(:endpoint_id) }
    it { is_expected.to validate_presence_of(:http_status_code) }
    it { is_expected.to validate_numericality_of(:http_status_code).only_integer }
    it { is_expected.to validate_presence_of(:endpoint) }
  end
end
