require 'rails_helper'

RSpec.describe 'POST /login', type: :request do
  let(:user) { Fabricate(:user) }
  let(:url) { '/login' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
    it 'returns 200' do
      post url, params: params
      expect(response).to have_http_status(200)
      expect(json).to eq(serialized(user))
    end
  end

  context 'when login params are incorrect' do
    before { post url }
    it_behaves_like 'unauthorized request'
  end
end
