require 'rails_helper'

RSpec.describe Group, type: :model do
  subject(:slack_credentials) { Fabricate.build(:slack_credentials) }

  describe '#valid?' do
    it { is_expected.to validate_presence_of(:webhook_url) }
    it { is_expected.to validate_presence_of(:access_token) }
    it 'has valid fabricator' do
      expect(Fabricate.build(:slack_credentials)).to be_valid
    end
  end
end
