require 'rails_helper'

RSpec.describe 'DELETE /headers/:id', type: :request do
  let(:header) { Fabricate :response_header }
  let(:header_id) { header.id }
  let(:url) { "/api/v1/headers/#{header_id}" }

  context 'when user is unauthenticated' do
    before { delete url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the header' do
    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'forbidden'
  end

  context 'when header does not exist' do
    let(:header_id) { -1 }

    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the header' do
    before do
      login_as header.user, scope: :user
      delete url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(json).to eq(serialized(header))
    end
  end
end
