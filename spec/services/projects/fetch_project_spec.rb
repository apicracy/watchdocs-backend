require 'rails_helper'

RSpec.describe Projects::FetchProject do
  let(:service) { described_class.new(project_id) }
  let(:project_id) { project.id }
  let(:project) { Fabricate(:project) }

  describe 'when passing valid parameters' do
    it 'returns relevant project' do
      returned_project = service.call
      expect(returned_project.id).to be project.id
    end
  end

  describe 'when passing invalid params' do
    let(:project_id) { project.id + 1 }

    it 'raises ActiveRecord::RecordNotFound exception' do
      expect { service.call }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
