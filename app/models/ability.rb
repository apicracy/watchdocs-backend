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

    # Endpoint
    can :crud, Endpoint do |endpoint|
      can? :crud, endpoint.project
    end

    # Request
    can :crud, Request do |request|
      can? :crud, request.endpoint
    end
  end
end
