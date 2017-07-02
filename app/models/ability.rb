class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    # Project
    can :index, Project
    can :crud, Project, user: user
    can :read_documentation, Project, user: user
    can :read_documentation, Project, public: true

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

    # Response
    can :crud, Response do |response|
      can? :crud, response.endpoint
    end

    # UrlParam
    can :crud, UrlParam do |param|
      can? :crud, param.endpoint
    end

    # Header
    can :crud, Header do |header|
      can? :crud, header.headerable
    end

    # Document
    can :crud, Document do |document|
      can? :crud, document.project
    end

    # Group
    can :crud, Group do |group|
      can? :crud, group.project
    end

    # Notifications::Channel
    can :update, Notifications::Channel do |channel|
      channel.user_id == user.id
    end

    # TreeItem
    can :crud, TreeItem do |tree_item|
      can? :crud, tree_item.itemable
    end
  end
end
