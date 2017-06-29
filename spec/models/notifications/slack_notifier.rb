require 'rails_helper'

RSpec.describe Group, type: :model do
  subject(:slack_notifier) { Fabricate.build(:slack_notifier) }

  describe '#valid?' do
    it { is_expected.to validate_presence_of(:webhook_url) }
    it { is_expected.to validate_presence_of(:access_token) }
    it 'has valid fabricator' do
      expect(Fabricate.build(:slack_notifier)).to be_valid
    end
  end

  describe '#notify' do
    before do
      stub_request(:post, slack_notifier.webhook_url).to_return(status: 200)
      slack_notifier.notify('message')
    end

    it 'sends data to slack via post request' do
      expect(a_request(:post, slack_notifier.webhook_url)).to have_been_made
    end
  end
end
