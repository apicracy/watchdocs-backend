require 'rails_helper'

RSpec.describe 'POST /headers', type: :request do
  let(:headerable) { Fabricate :request }
  let(:headerable_id) { headerable.id }
  let(:url) { '/api/v1/headers' }
  let(:params) do
    {
      headerable_id: headerable_id,
      headerable_type: headerable.class,
      key: 'X-FORWARDED-FOR',
      required: true,
      description: Faker::Lorem.sentence,
      example_value: Faker::Lorem.word
    }
  end

  context 'when user is not signed in' do
    before { post url, params: params }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not owner of a parent object' do
    before do
      login_as Fabricate(:user), scope: :user
      post url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when parent obect does not exist' do
    let(:headerable_id) { -1 }

    before do
      login_as Fabricate :user
      post url, params: params
    end

    # TODO: Change to not_found in the future
    it_behaves_like 'forbidden'
  end

  context 'when user owns parent object' do
    context 'and params are valid for request' do
      before do
        login_as headerable.user, scope: :user
        post url, params: params
      end

      it 'returns OK status' do
        expect(response.status).to eq 200
      end

      it 'creates new header' do
        expect(Header.count).to eq 2 # created one and one from endpoint url
      end

      it 'sets up_to_date status by default' do
        expect(Header.last.status).to eq('up_to_date')
      end

      it 'returns serialized header' do
        expect(json).to eq(serialized(Header.last))
      end
    end

    context 'and params are valid for response' do
      let(:headerable) { Fabricate :response }

      before do
        login_as headerable.user, scope: :user
        post url, params: params
      end

      it 'returns OK status' do
        expect(response.status).to eq 200
      end

      it 'creates new header' do
        expect(Header.count).to eq 2 # created one and one from endpoint url
      end

      it 'sets up_to_date status by default' do
        expect(Header.last.status).to eq('up_to_date')
      end

      it 'returns serialized header' do
        expect(json).to eq(serialized(Header.last))
      end
    end

    context 'and params are invalid' do
      before do
        login_as headerable.user, scope: :user
        post url, params: params.except(:key) # Missing: key
      end

      it_behaves_like 'invalid'
    end
  end
end
