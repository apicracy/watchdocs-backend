require 'rails_helper'

RSpec.describe Header, type: :model do
  subject(:header) { Fabricate.build(:request_header) }

  describe '#valid?' do
    it 'validates uniqness of key across headerable' do
      expect(header).to validate_uniqueness_of(:key)
        .scoped_to(:headerable_id, :headerable_type)
    end
    it { is_expected.to validate_presence_of(:headerable) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:required) }
  end
end
