require 'cancan/matchers'
require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:user) { nil }
  subject(:ability) { Ability.new(user) }

  # Guest
  # ----
  context 'when is a guest' do
    # Project
    it { is_expected.not_to be_able_to(:crud, Project.new) }

    # User
    it { is_expected.not_to be_able_to(:read, User.new(id: 1)) }
  end

  context 'when is a signed in user' do
    let(:user) { Fabricate :user }

    # Project
    it { is_expected.not_to be_able_to(:crud, Project.new) }
    it { is_expected.to be_able_to(:crud, Project.new(user: user)) }
    it { is_expected.to be_able_to(:index, Project) }

    # User
    it { is_expected.to be_able_to(:read, user) }
    it { is_expected.not_to be_able_to(:read, User.new(id: 10)) }
  end
end
