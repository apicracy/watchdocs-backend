require 'cancan/matchers'
require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }
  let(:user) { nil }

  # Guest
  # ----
  context 'when is a guest' do
    # Project
    it { is_expected.not_to be_able_to(:crud, Project.new(user_id: 3)) }
    it { is_expected.not_to be_able_to(:read_documentation, Project.new(user_id: 3)) }
    it { is_expected.to be_able_to(:read_documentation, Project.new(user_id: 3, public: true)) }

    # User
    it { is_expected.not_to be_able_to(:read, User.new(id: 1)) }

    # Endpoint
    it { is_expected.not_to be_able_to(:crud, Endpoint.new) }

    # Request
    it { is_expected.not_to be_able_to(:crud, Request.new) }

    # Response
    it { is_expected.not_to be_able_to(:crud, Response.new) }

    # UrlParam
    it { is_expected.not_to be_able_to(:crud, UrlParam.new) }

    # Header
    it { is_expected.not_to be_able_to(:crud, Header.new) }

    # Header
    it { is_expected.not_to be_able_to(:crud, Group.new) }
  end

  context 'when is a signed in user' do
    let(:user) { Fabricate :user }
    let(:owned_project) { Fabricate :project, user: user }
    let(:owned_endpoint) { Fabricate :endpoint, project: owned_project }

    # User
    it { is_expected.to be_able_to(:read, user) }
    it { is_expected.not_to be_able_to(:read, User.new(id: 10)) }

    # Project
    it { is_expected.not_to be_able_to(:crud, Project.new) }
    it { is_expected.to be_able_to(:crud, Project.new(user: user)) }
    it { is_expected.to be_able_to(:index, Project) }

    # Endpoint
    it do
      is_expected.to be_able_to(
        :read, Endpoint.new(project: owned_project)
      )
    end

    it do
      is_expected.not_to be_able_to(
        :crud, Endpoint.new(project: Project.new)
      )
    end

    # Request
    it do
      is_expected.to be_able_to(
        :crud, Request.new(endpoint: owned_endpoint)
      )
    end

    # Response
    it do
      is_expected.to be_able_to(
        :crud, Response.new(endpoint: owned_endpoint)
      )
    end

    # UrlParam
    it do
      is_expected.to be_able_to(
        :crud, UrlParam.new(endpoint: owned_endpoint)
      )
    end

    # Header
    it do
      is_expected.to be_able_to(
        :crud, Header.new(headerable: owned_endpoint.request)
      )
    end

    # Group
    it do
      is_expected.to be_able_to(
        :read, Group.new(project: owned_project)
      )
    end

    it do
      is_expected.not_to be_able_to(
        :crud, Group.new(project: Project.new)
      )
    end
  end
end
