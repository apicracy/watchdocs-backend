require 'rails_helper'

RSpec.describe 'POST /users/reset_password_token', type: :request do
  let(:user) { Fabricate(:user) }
  let(:email) { user.email }
  let(:url) { '/api/v1/users/reset_password_token' }
  let(:params) do
    {
      email: email
    }
  end

  context 'when provided email matches a user' do
    before do
      get url, params: params
    end

    it 'returns 204' do
      expect(response).to have_http_status(204)
    end

    it 'sends reset password email' do
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end

  context 'when provided email does NOT matches a user' do
    let(:email) { 'some@fakeemail.com' }

    before do
      get url, params: params
    end

    it 'returns 204' do
      expect(response).to have_http_status(204)
    end

    it 'does NOT send reset password email' do
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end
  end
end
