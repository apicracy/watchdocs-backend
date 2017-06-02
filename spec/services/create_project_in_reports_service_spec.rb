require 'rails_helper'

RSpec.describe CreateProjectInReportsService do
  subject(:creator) { described_class.new(project) }
  let(:project) { Fabricate.build(:project) }
  let(:body) do
    {
      app_id: project.app_id,
      app_secret: project.app_secret
    }
  end

  context 'when project is valid' do
    before do
      stub_request(:post, /#{described_class::REPORTS_SERVICE_PROJECTS_PATH}/)
        .to_return(status: 200)
    end

    it 'returns true' do
      result = creator.call
      expect(result).to be_truthy
    end

    it 'makes a call to reports service' do
      creator.call
      expect(a_request(:post, /#{described_class::REPORTS_SERVICE_PROJECTS_PATH}/)
        .with(
          body: body,
          headers: { 'Content-Type' => 'application/json' }
        )
      ).to have_been_made
    end
  end

  context 'when project is not valid' do
    before do
      stub_request(:post, /#{described_class::REPORTS_SERVICE_PROJECTS_PATH}/)
        .to_return(
          status: 400,
          body: '{"errors":"\nmessage:\n  Validation of Project failed."}'
        )
    end

    it 'returns raises error' do
      expect { creator.call }.to raise_error(ReportsServiceError)
    end
  end
end
