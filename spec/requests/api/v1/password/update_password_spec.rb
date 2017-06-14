require 'rails_helper'

RSpec.describe 'PUT /users/passwords', type: :request do
  let(:url) { "/api/v1/users/passwords/#{public_token}" }
  let(:user) { Fabricate(:user) }
  let(:email) { user.email }
  let(:password) { 'pass' }
  let(:params) do
    {
      password: password,
      password_confirmation: 'pass'
    }
  end
  let!(:public_token) do
    CreateResetPasswordToken.new(email).call
  end

  context 'when token is valid and passwords match' do
    it 'returns 204' do
      put url, params: params
      expect(response).to have_http_status(204)
    end

    it 'sends email about password being changed' do
      expect { put url, params: params }
        .to change { ActionMailer::Base.deliveries.size }.by 1
    end
  end

  context 'when token is invalid' do
    let(:public_token) { 'w948vn09c8409a' }

    before do
      put url, params: params
    end

    it_behaves_like 'invalid'

    it 'returns token validation error' do
      expect(json['errors'].first['detail']['reset_password_token'])
        .to be_present
    end
  end

  context 'when token is valid and passwords do not match' do
    let(:password) { 'pass123' }

    before do
      put url, params: params
    end

    it_behaves_like 'invalid'

    it 'returns password validation error' do
      expect(json['errors'].first['detail']['password_confirmation'])
        .to be_present
    end
  end

  context 'when token has expired' do
    before do
      Delorean.jump 8.hours.to_i
      put url, params: params
      Delorean.back_to_the_present
    end

    it_behaves_like 'invalid'

    it 'returns token validation error' do
      expect(json['errors'].first['detail']['reset_password_token'])
        .to be_present
    end
  end
end
