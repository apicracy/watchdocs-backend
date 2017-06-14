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
  let(:public_token) do
    CreateResetPasswordToken.new(email).call
  end

  context 'when token is valid and passwords match' do
    before do
      put url, params: params
    end

    it 'returns 204' do
      expect(response).to have_http_status(204)
    end
  end

  context 'when token is invalid' do
    let(:public_token) { 'w948vn09c8409a' }

    before do
      put url, params: params
    end

    it_behaves_like 'invalid'
  end

  context 'when token is valid and passwords do not match' do
    let(:password) { 'pass123' }

    before do
      put url, params: params
    end

    it_behaves_like 'invalid'
  end

  context 'when token has expired' do
    before do
      time_travel_to(8.hours.ago) { public_token }
      put url, params: params
    end

    it_behaves_like 'invalid'
  end
end
