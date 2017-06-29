require 'rails_helper'

RSpec.describe Notifications::SendSlackNotification do
  subject(:service) { described_class.new(channels: slack_channels, message: 'test message') }
  let(:user) { Fabricate :user }
  let!(:slack_channel) { Fabricate :slack_channel, user_id: user.id }
  let(:slack_channels) { Notifications::Channel.where(user_id: user.id).slack }

  context 'channels provided' do
    before do
      stub_request(:post, slack_channel.notificable.webhook_url).to_return(status: 200)
    end

    it 'sends data to slack via post request' do
      service.call
      expect(a_request(:post, slack_channel.notificable.webhook_url)).to have_been_made
    end
  end
end
