class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    # Project
    can :index, Project
    can :crud, Project, user: user

    # User
    can :read, User, id: user.id
  end
end
