require 'rails_helper'

RSpec.describe Notifications::SendPushNotification do
  subject(:service) { described_class.new(channels: channels, message: message) }
  let(:channel) { Fabricate(:push_notification_channel) }
  let(:channels) { Notifications::Channel.where(id: channel.id) }
  let(:message) { 'Test message.' }

  context 'when parameters valid', vcr: true do
    it 'is successful' do
      service.call
      expect(service).to be_success
    end

    it 'sends notification through OneSignal' do
      service.call
      expect(a_request(:post, 'https://onesignal.com/api/v1/notifications')).to have_been_made
    end
  end

  context 'when parameters invalid', vcr: true do
    let(:error_message) { { errors: ['Some error message'] }.to_json }

    before do
      stub_request(:post, 'https://onesignal.com/api/v1/notifications').to_return(
        body: error_message, status: 400
      )
    end

    it 'is unsuccessful' do
      service.call
      expect(service).not_to be_success
    end

    it 'tries to send notification through OneSignal' do
      service.call
      expect(a_request(:post, 'https://onesignal.com/api/v1/notifications')).to have_been_made
    end

    it 'returns error messages' do
      expect(service.call).to have_key 'errors'
    end
  end
end
