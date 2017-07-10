require 'rails_helper'

RSpec.describe Projects::FetchUsers do
  let(:service) { described_class.new(project_id) }
  let(:project_id) { project.id }
  let(:user) { project.user }
  let(:project) { Fabricate(:project) }

  describe 'when passing valid parameters' do
    it 'returns relevant users' do
      returned_users = service.call
      expect(returned_users.map(&:id)).to include(user.id)
    end
  end

  describe 'when passing invalid params' do
    let(:project_id) { project.id + 1 }

    it 'raises ActiveRecord::RecordNotFound exception' do
      returned_users = service.call
      expect(returned_users).to be_empty
    end
  end
end
