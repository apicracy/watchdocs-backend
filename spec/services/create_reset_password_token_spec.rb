require 'rails_helper'

RSpec.describe CreateResetPasswordToken do
  subject(:token_creator) { described_class.new(email) }
  let(:user) { Fabricate(:user) }
  let(:email) { user.email }

  before do
    allow(UserPasswordMailer).to(
      receive(:reset_instructions).and_return(double(deliver_now: nil))
    )
  end

  context 'when user with given email exists' do
    before { token_creator.call }

    it 'creates new reset password for the user' do
      expect(user.reload.reset_password_token).to be_present
    end

    it 'sets time of the token creation' do
      expect(user.reload.reset_password_sent_at).to be_present
    end

    it 'sends reset password email' do
      expect(UserPasswordMailer).to have_received(:reset_instructions)
        .with(token_creator.user.id, token_creator.public_token)
    end
  end

  context 'when user with given email DOES NOT exist' do
    let(:email) { 'fake@email.com' }

    it 'returns nil' do
      expect(token_creator.call).to be_nil
    end

    it 'does not send reset password email' do
      expect(UserPasswordMailer).not_to have_received(:reset_instructions)
    end
  end
end
