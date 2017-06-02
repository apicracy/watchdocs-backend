class CreateProject
  attr_reader :project

  def initialize(initail_params)
    @project = Project.new(initail_params)
  end

  def call
    project.generate_api_credentials
    begin
      CreateProjectInReportsService.new(project).call
      project.save
    rescue ReportsServiceError => e
      project.errors.add(:name, e.message)
    end
    project
  end
end
