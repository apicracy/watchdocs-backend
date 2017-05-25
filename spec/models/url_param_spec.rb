require 'rails_helper'

RSpec.describe UrlParam, type: :model do
  subject(:url_param) { Fabricate.build(:url_param, endpoint: endpoint) }
  let(:endpoint) { Fabricate(:endpoint) }

  describe '#valid?' do
    it 'validates uniqness of name across endpoint' do
      expect(url_param).to validate_uniqueness_of(:name)
        .scoped_to(:is_part_of_url, :endpoint_id)
    end
    it { is_expected.to validate_presence_of(:endpoint) }
  end

  describe '#set_status' do
    context 'having only required set' do
      let(:url_param) do
        Fabricate(:url_param, required: false)
      end

      it 'sets up_to_date status' do
        expect(url_param).to be_up_to_date
      end
    end

    context 'having required and required_draft set' do
      let(:url_param) do
        Fabricate(:url_param,
                  required: false,
                  required_draft: false)
      end

      it 'sets outdated status' do
        expect(url_param).to be_outdated
      end
    end
  end
end
