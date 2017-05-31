require 'rails_helper'

RSpec.describe Header, type: :model do
  subject(:header) { Fabricate.build :header }

  describe '#valid?' do
    it 'validates uniqness of key across headerable' do
      expect(header).to validate_uniqueness_of(:key)
        .scoped_to(:headerable_id, :headerable_type)
    end
    it { is_expected.to validate_presence_of(:headerable) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:required) }
  end

  it 'has valid request header fabricator' do
    expect(Fabricate.build(:request_header)).to be_valid
  end

  it 'has valid response header fabricator' do
    expect(Fabricate.build(:response_header)).to be_valid
  end
end
