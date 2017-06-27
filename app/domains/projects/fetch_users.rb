module Projects
  class FetchUsers
    def call(project_id)
      # It will be something like that later as we need user's collection
      # Project.find(project_id).users
      ::User.where(id: ::Project.where(id: project_id).select(:user_id))
    end
  end
end
