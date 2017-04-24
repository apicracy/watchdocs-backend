require 'rails_helper'

RSpec.describe Header, type: :model do
  subject(:header) { Fabricate.build :header }

  describe '#valid?' do
    it { is_expected.to validate_uniqueness_of(:key).scoped_to([:headerable_id, :headerable_type]) }
  end

  it 'has valid fabricator' do
    expect(header).to be_valid
  end

  describe '#update_required' do
    let(:header) { Fabricate.build :header, required: previous_required }
    let(:previous_required) { true }
    let(:new_required) { false }

    before do
      header.update_required(new_required)
    end

    context 'required was not yet set' do
      let(:previous_required) { nil }

      it "sets 'required' column" do
        expect(header.required).to eq(new_required)
      end

      it "does not set 'required_draft' column" do
        expect(header.required_draft).to be_nil
      end
    end

    context 'required was set to a different value' do
      it "sets 'required_draft' column" do
        expect(header.required_draft).to eq(new_required)
      end

      it "does not affet 'required' column" do
        expect(header.required).to eq(previous_required)
      end
    end

    context 'required was set to the same value' do
      let(:previous_required) { new_required }

      it "does not set 'required_draft' column" do
        expect(header.required_draft).to be_nil
      end
    end
  end

  describe '#set_status' do
    context 'when any pending drafts' do
      subject(:header) do
        Fabricate :request_header,
                  required: false,
                  required_draft: true,
                  status: nil
      end

      it "sets status to 'outdated' on save" do
        expect(header.status).to eq('outdated')
      end
    end

    context 'when in fresh state' do
      subject(:header) do
        Fabricate :request_header,
                  required: false,
                  required_draft: true,
                  status: :fresh
      end

      it "stays in 'fresh' state even if draft is present" do
        expect(header.status).to eq('fresh')
      end
    end

    context 'when in stale state' do
      subject(:header) do
        Fabricate :request_header,
                  required: false,
                  required_draft: true,
                  status: :stale
      end

      it "stays in 'stale' state even if draft is present" do
        expect(header.status).to eq('stale')
      end
    end
  end
end
