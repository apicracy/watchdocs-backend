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
        Fabricate(:request, body: json_schema_sample)
      end

      it 'sets up_to_date status' do
        expect(request).to be_up_to_date
      end
    end

    context 'having body and body_draft set' do
      let(:request) do
        Fabricate(:request,
                  body: json_schema_sample,
                  body_draft: json_schema_sample)
      end

      it 'sets outdated status' do
        expect(request).to be_outdated
      end
    end
  end
end
