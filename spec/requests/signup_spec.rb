require 'rails_helper'

RSpec.describe 'POST /sign_up', type: :request do
  let(:url) { '/sign_up' }
  let(:params) do
    {
      email: 'user@example.com',
      password: 'password'
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user already exists' do
    before do
      Fabricate :user, email: params[:email]
      post url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when user is already signed in' do
    before do
      login_as Fabricate :user, scope: :user
      post url, params: params
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(response.body).to match_schema('document')
    end
  end
end
