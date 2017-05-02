require 'rails_helper'

RSpec.describe Group, type: :model do
  subject(:group) { Fabricate.build(:group) }

  describe '#valid?' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:project) }
  end
end
