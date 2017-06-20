require 'rails_helper'

RSpec.describe Project, type: :model do
  subject(:project) { Fabricate.build(:project, name: 'Sample project') }

  describe '#valid?' do
    it { is_expected.to validate_uniqueness_of(:name).scoped_to([:user_id]) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:app_id) }
    it { is_expected.to validate_presence_of(:app_secret) }

    it { is_expected.to allow_value('http://test.com').for(:base_url) }
    it { is_expected.not_to allow_value('test.com').for(:base_url) }
    it { is_expected.not_to allow_value('.com').for(:base_url) }
    it { is_expected.not_to allow_value('test').for(:base_url) }
  end

  describe '#slug' do
    it 'creates a slug on save' do
      project.save
      expect(project.slug).to eq('sample-project')
    end

    context 'when project under the same name exists' do
      before do
        Fabricate :project, name: project.name
      end

      it 'sets to something different' do
        project.save
        expect(project.slug).to include('sample-project')
        expect(project.slug).not_to eq('sample-project')
      end
    end
  end
end
