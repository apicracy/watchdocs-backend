require 'rails_helper'

RSpec.describe Response, type: :model do
  subject(:response) { Fabricate.build :response }

  it { is_expected.to validate_uniqueness_of(:http_status_code).scoped_to(:endpoint_id) }
  it { is_expected.to validate_presence_of(:http_status_code) }
  it { is_expected.to validate_numericality_of(:http_status_code).only_integer }
  it { is_expected.to validate_presence_of(:endpoint) }
end
