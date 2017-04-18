require 'cancan/matchers'
require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:user) { nil }
  subject(:ability) { described_class.new(user) }

  # Guest
  # ----
  context 'when is a guest' do
    # Project
    it { is_expected.not_to be_able_to(:crud, Project.new(user_id: 3)) }

    # User
    it { is_expected.not_to be_able_to(:read, User.new(id: 1)) }

    # Endpoint
    it { is_expected.not_to be_able_to(:crud, Endpoint.new) }

    # Request
    it { is_expected.not_to be_able_to(:crud, Request.new) }
  end

  context 'when is a signed in user' do
    let(:user) { Fabricate :user }
    let(:owned_project) { Fabricate :project, user: user }
    let(:owned_endpoint) { Fabricate :endpoint, project: owned_project }

    # Project
    it { is_expected.not_to be_able_to(:crud, Project.new) }
    it { is_expected.to be_able_to(:crud, Project.new(user: user)) }
    it { is_expected.to be_able_to(:index, Project) }

    # User
    it { is_expected.to be_able_to(:read, user) }
    it { is_expected.not_to be_able_to(:read, User.new(id: 10)) }

    # Request
    it { is_expected.to be_able_to(:crud, Request.new(endpoint: owned_endpoint)) }

    # Endpoint
    it { is_expected.to be_able_to(:read, Endpoint.new(project: owned_project)) }
    it do
      is_expected.not_to be_able_to(:crud, Endpoint.new(project: Project.new))
    end
  end
end
