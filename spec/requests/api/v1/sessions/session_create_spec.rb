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
    before { post url, params: params }

    it 'returns 200' do
      expect(response).to have_http_status(200)
      expect(json).to eq(serialized(user))
    end

    xit 'returns JTW token in authorization header' do
      expect(response).to have_http_status(200)
    end
  end

  context 'when login params are incorrect' do
    before { post url }
    it_behaves_like 'unauthorized request'
  end
end
