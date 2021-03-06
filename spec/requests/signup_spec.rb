require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/signup' }
  let(:email) { 'user@example.com' }
  let(:password) { 'password' }
  let(:params) do
    {
      user: {
        email: email,
        password: password,
        password_confirmation: 'password'
      }
    }
  end

  before do
    allow_any_instance_of(ActiveCampaignTracking).to(
      receive(:add_to_contacts).and_return(true)
    )
  end

  context 'when user is unauthenticated' do
    it 'returns 200' do
      post url, params: params
      expect(response.status).to eq 200
    end

    it 'returns a new user' do
      post url, params: params
      expect(response.body).to match_schema('user')
    end

    it 'sends welcome email' do
      post url, params: params
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it 'tracks new signup with Active Campaign' do
      expect_any_instance_of(ActiveCampaignTracking).to(
        receive(:add_to_contacts).once
      )
      post url, params: params
    end
  end

  context 'when user already exists' do
    before do
      Fabricate :user, email: params[:user][:email]
      post url, params: params
    end

    it_behaves_like 'invalid'
  end

  context 'when email is not valid' do
    let(:email) { 'a@' }
    before { post url, params: params }

    it_behaves_like 'invalid'
  end

  context 'when password_confirmation does not match' do
    let(:password) { 'otherpass' }
    before { post url, params: params }

    it_behaves_like 'invalid'
  end

  context 'when user is already signed in' do
    before do
      login_as Fabricate(:user), scope: :user
      post url, params: params
    end

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns a new user' do
      expect(response.body).to match_schema('user')
    end
  end
end
