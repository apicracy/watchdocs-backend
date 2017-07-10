module Projects
  class FetchProject
    attr_reader :project_id

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      ::Project.find(project_id)
    end
  end
end
