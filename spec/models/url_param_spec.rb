require 'rails_helper'

RSpec.describe UrlParam, type: :model do
  subject(:url_param) { Fabricate.build :url_param }

  describe '#valid?' do
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:endpoint_id) }
    it { is_expected.to validate_presence_of(:endpoint) }
  end
end
