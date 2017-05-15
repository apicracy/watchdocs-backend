require 'rails_helper'

RSpec.describe 'DELETE /documents/:id', type: :request do
  let(:document) { Fabricate :document }
  let(:document_id) { document.id }
  let(:url) { "/api/v1/documents/#{document_id}" }

  context 'when user is unauthenticated' do
    before { delete url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the document' do
    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'forbidden'
  end

  context 'when document does not exist' do
    let(:document_id) { -1 }

    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the document' do
    before do
      login_as document.project.user, scope: :user
      delete url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(response.body).to match_schema('document')
    end
  end
end
