require 'rails_helper'

RSpec.describe 'DELETE /responses/:id', type: :request do
  let(:expected_response) { Fabricate :response }
  let(:response_id) { expected_response.id }
  let(:url) { "/api/v1/responses/#{response_id}" }

  context 'when user is unauthenticated' do
    before { delete url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the response' do
    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'forbidden'
  end

  context 'when response does not exist' do
    let(:response_id) { -1 }

    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the response' do
    before do
      # TODO: Change after merge
      login_as expected_response.user, scope: :user
      delete url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(response.body).to match_schema('response')
    end

    it 'removes all connected headers' do
      expect(Header.count).to eq 0
    end
  end
end
