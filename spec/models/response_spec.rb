require 'rails_helper'

RSpec.describe Response, type: :model do
  subject(:response) { Fabricate.build(:response) }

  describe '#valid?' do
    it { is_expected.to allow_value(type: 'array').for(:body) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body) }
    it { is_expected.to allow_value(type: 'array').for(:body_draft) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body_draft) }
    it { is_expected.to validate_uniqueness_of(:http_status_code).scoped_to(:endpoint_id) }
    it { is_expected.to validate_presence_of(:http_status_code) }
    it { is_expected.to validate_numericality_of(:http_status_code).only_integer }
    it { is_expected.to validate_presence_of(:endpoint) }
  end

  describe '#set_status' do
    context 'having only body set' do
      let(:response) do
        Fabricate(:response, body: json_schema_sample)
      end

      it 'sets up_to_date status' do
        expect(response).to be_up_to_date
      end
    end

    context 'having body and body_draft set' do
      let(:response) do
        Fabricate(:response,
                  body: json_schema_sample(items_in_array: 'string'),
                  body_draft: json_schema_sample(items_in_array: 'number'))
      end

      it 'sets outdated status' do
        expect(response).to be_outdated
      end
    end
  end

  describe '#normalize_json_schemas' do
    context 'when body changes' do
      let(:response) do
        Fabricate.build(:response, body: old_body)
      end
      let(:old_body) { json_schema_sample(items_in_array: 'string') }
      let(:new_body) { json_schema_sample(items_in_array: 'number') }

      before do
        response.save
      end

      it 'calls normalizer with new value' do
        allow(JsonSchemaNormalizer).to receive(:normalize)
        response.update(body: new_body)
        expect(JsonSchemaNormalizer).to have_received(:normalize).with(new_body).once
      end
    end

    context 'when body_draft changes' do
      let(:response) do
        Fabricate.build(:response, body: json_schema_sample(items_in_array: 'array'), body_draft: new_body)
      end
      let(:old_body) { json_schema_sample(items_in_array: 'string').deep_stringify_keys }
      let(:new_body) { json_schema_sample(items_in_array: 'number').deep_stringify_keys }

      before do
        response.save
      end

      it 'calls normalizer with new value' do
        allow(JsonSchemaNormalizer).to receive(:normalize)
        response.update(body: new_body)
        expect(JsonSchemaNormalizer).to have_received(:normalize).with(new_body).once
      end
    end
  end

  describe '#cleanup_unnecessary_draft' do
    let(:request) { Fabricate(:request, body: body, body_draft: body_draft) }
    let(:body) { nil }
    let(:body_draft) { nil }

    context 'when body does not exist but draft exists' do
      let(:body) { nil }
      let(:body_draft) { json_schema_sample }

      it 'saves draft as body' do
        expect(request.reload.body).to eq(body_draft)
      end

      it 'does not save anything to draft' do
        expect(request.reload.body_draft).to be_nil
      end
    end

    context 'when body and draft are the same' do
      let(:body) { json_schema_sample }
      let(:body_draft) { body }

      it 'clears draft' do
        expect(request.reload.body_draft).to be_nil
      end
    end

    context 'when body and draft are different' do
      let(:body) { json_schema_sample(items_in_array: 'string') }
      let(:body_draft) { json_schema_sample(items_in_array: 'number') }

      it 'saves draft as body' do
        expect(request.reload.body).to eq(body)
      end

      it 'does not save anything to draft' do
        expect(request.reload.body_draft).to eq(body_draft)
      end
    end
  end
end
