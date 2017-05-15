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
end
