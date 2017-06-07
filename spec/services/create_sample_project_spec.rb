require 'rails_helper'

RSpec.describe CreateSampleProject do
  let(:project) { Fabricate(:project) }
  let(:user) { project.user }
  let(:sample_project) { user.projects.samples.first }

  context 'when user have one project' do
    before do
      described_class.new(user).call
    end

    it 'creates new sample project for the user' do
      expect(sample_project).to be_present
    end

    it 'creates 3 groups for sample project' do
      expect(sample_project.groups.count).to eq 3
    end

    it 'creates some outdated endpoints' do
      expect(sample_project.endpoints.outdated).to be_present
    end

    it 'creates some up-to-date endpoints' do
      expect(sample_project.endpoints.up_to_date).to be_present
    end

    it 'creates some outdated responses' do
      expect(Response.outdated).to be_present
    end

    it 'creates some up-to-date responses' do
      expect(Response.up_to_date).to be_present
    end
  end

  context 'when user does not have projects' do
    before do
      described_class.new(Fabricate(:user)).call
    end

    it 'does not create new sample project for the user' do
      expect(sample_project).to be_nil
    end
  end

  context 'when user does have an sample project already' do
    before do
      Fabricate(:project, user: user, sample: true)
    end

    it 'does not create new sample project for the user' do
      expect { described_class.new(user).call }.not_to(
        change { user.projects.samples.count }
      )
    end
  end
end
