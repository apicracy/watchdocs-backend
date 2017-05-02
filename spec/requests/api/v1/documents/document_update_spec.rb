require 'rails_helper'

RSpec.describe 'PUT /documents/:id', type: :request do
  let(:document) { Fabricate :document }
  let(:document_id) { document.id }
  let(:project) { Fabricate :project }
  let(:url) { "/api/v1/documents/#{document_id}" }
  let(:params) do
    {
      project_id: project.id,
      name: Faker::Lorem.word,
      text: Faker::Lorem.paragraph
    }
  end

  context 'when user is unauthenticated' do
    before { put url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the document' do
    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when document does not exist' do
    let(:document_id) { -1 }

    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the document' do
    let(:user) { document.project.user }

    context 'and params are valid' do
      let(:project_id) { document.project_id }

      before do
        login_as user, scope: :user
        put url, params: params
      end

      it 'returns 200 and serialized updated document' do
        expect(response.status).to eq 200
        expect(json).to eq(serialized(document.reload))
      end

      it 'does not update project' do
        expect(json['project_id']).to eq project_id
      end
    end

    context 'params are invalid' do
      before do
        params[:name] = nil
        login_as user, scope: :user
        put url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
