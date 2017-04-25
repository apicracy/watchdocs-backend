require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  subject(:endpoint) { Fabricate.build(:endpoint) }

  describe '#valid?' do
    it { is_expected.to validate_uniqueness_of(:url).scoped_to(:http_method) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:http_method) }
    it { is_expected.to validate_presence_of(:project) }

    it { is_expected.to allow_value('/v1/projects/:id').for(:url) }
    it { is_expected.to allow_value('/v1').for(:url) }
    it { is_expected.not_to allow_value('/v1/').for(:url) }
    it { is_expected.not_to allow_value('/v1?param=1').for(:url) }
    it { is_expected.not_to allow_value('/v1/projects/').for(:url) }
    it { is_expected.not_to allow_value('/v1/pa:ram').for(:url) }
  end
end
