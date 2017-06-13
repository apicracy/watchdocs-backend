require 'rails_helper'

RSpec.describe UserPasswordMailer, type: :mailer do
  describe 'reset_instructions' do
    let(:user) { Fabricate(:user) }
    let(:token) { 'qv34tq4taervav' }
    let(:mail) { described_class.reset_instructions(user.id, token).deliver_now }

    it 'contains link to reset password with token' do
      expect(mail.body.encoded)
        .to include("https://app.watchdocs.io/reset_password?token=#{token}")
    end
  end
end
