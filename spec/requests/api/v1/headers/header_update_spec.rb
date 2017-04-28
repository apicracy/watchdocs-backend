require 'rails_helper'

RSpec.describe 'PUT /headers/:id', type: :request do
  let(:header) { Fabricate :request_header }
  let(:header_id) { header.id }
  let(:url) { "/api/v1/headers/#{header_id}" }
  let(:params) do
    {
      headerable_id: 12,
      headerable_type: 'Response',
      key: 'X-FORWARDED-FOR',
      required: true,
      description: Faker::Lorem.sentence,
      example_value: Faker::Lorem.word
    }
  end

  context 'when user is not signed in' do
    before { put url, params: params }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not owner of header' do
    before do
      login_as Fabricate(:user), scope: :user
      put url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when header does not exist' do
    let(:header_id) { -1 }

    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when params are correct and user owns header' do
    let(:headerable_id) { header.headerable_id }

    before do
      login_as header.user, scope: :user
      put url, params: params
    end

    it 'returns 200 and serialized updated endpoint' do
      expect(response.status).to eq 200
      expect(json).to eq(serialized(header.reload))
    end

    it 'does not update headerable' do
      expect(json['headerable_id']).to eq headerable_id
      expect(json['headerable_type']).to eq 'Request'
    end
  end

  context 'when param params are incorrect' do
    before do
      Fabricate :request_header,
                key: 'test',
                headerable: header.headerable

      login_as header.user, scope: :user
      put url, params: { key: 'test' } # Duplicating keys
    end

    it_behaves_like 'invalid'
  end
end
