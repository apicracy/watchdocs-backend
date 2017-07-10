module Projects
  class FetchUsers
    attr_reader :project_id

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      # It will be something like that later as we need user's collection
      # Project.find(project_id).users
      ::User.where(id: select_users_for_project)
    end

    private

    def select_users_for_project
      ::Project.where(id: project_id).select(:user_id)
    end
  end
end
