require 'rails_helper'

RSpec.describe Request, type: :model do
  subject(:request) { Fabricate.build(:request) }

  describe '#valid?' do
    it { is_expected.to allow_value(type: 'array').for(:body) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body) }
    it { is_expected.to allow_value(type: 'array').for(:body_draft) }
    it { is_expected.not_to allow_value(type: 'hash').for(:body_draft) }
  end

  describe '#set_status' do
    context 'having only body set' do
      let(:request) do
        Fabricate(:request, body: schema_fixture('array_of_strings'))
      end

      it 'sets up_to_date status' do
        expect(request).to be_up_to_date
      end
    end

    context 'having body and body_draft set' do
      let(:request) do
        Fabricate(:request,
                  body: schema_fixture('array_of_strings'),
                  body_draft: schema_fixture('array_of_numbers'))
      end

      it 'sets outdated status' do
        expect(request).to be_outdated
      end
    end
  end

  describe '#normalize_json_schemas' do
    context 'when body changes' do
      let(:request) do
        Fabricate.build(:request, body: old_body)
      end
      let(:old_body) { schema_fixture('array_of_strings') }
      let(:new_body) { schema_fixture('array_of_numbers') }

      before do
        request.save
      end

      it 'calls normalizer with new value' do
        allow(JsonSchemaNormalizer).to receive(:new).and_return(double(normalize: nil))
        request.update(body: new_body)
        expect(JsonSchemaNormalizer).to have_received(:new).with(new_body).once
      end
    end

    context 'when body_draft changes' do
      let(:request) do
        Fabricate.build(:request, body: schema_fixture('basic'), body_draft: new_body)
      end
      let(:old_body) { schema_fixture('array_of_strings') }
      let(:new_body) { schema_fixture('array_of_numbers') }

      before do
        request.save
      end

      it 'calls normalizer with new value' do
        allow(JsonSchemaNormalizer).to receive(:new).and_return(double(normalize: nil))
        request.update(body: new_body)
        expect(JsonSchemaNormalizer).to have_received(:new).with(new_body).once
      end
    end
  end

  describe '#cleanup_unnecessary_draft' do
    let(:request) { Fabricate(:request, body: body, body_draft: body_draft) }
    let(:body) { nil }
    let(:body_draft) { nil }

    context 'when body does not exist but draft exists' do
      let(:body) { nil }
      let(:body_draft) { schema_fixture('array_of_strings') }

      it 'saves draft as body' do
        expect(request.reload.body).to eq(body_draft)
      end

      it 'does not save anything to draft' do
        expect(request.reload.body_draft).to be_nil
      end
    end

    context 'when body and draft are the same' do
      let(:body) { schema_fixture('array_of_strings') }
      let(:body_draft) { body }

      it 'clears draft' do
        expect(request.reload.body_draft).to be_nil
      end
    end

    context 'when body and draft are different' do
      let(:body) { schema_fixture('array_of_strings') }
      let(:body_draft) { schema_fixture('array_of_numbers') }

      it 'saves draft as body' do
        expect(request.reload.body).to eq(body)
      end

      it 'does not save anything to draft' do
        expect(request.reload.body_draft).to eq(body_draft)
      end
    end
  end
end
