class CreateProject
  attr_reader :project

  def initialize(initial_params)
    @project = Project.new(initial_params)
  end

  def call
    generate_api_credentials
    create_project_in_reports_service
    create_sample_project
    project
  end

  private

  def generate_api_credentials
    return if project.app_id && project.app_secret
    credentials = ApiCredentials.generate(project.name)
    return unless credentials
    project.assign_attributes(credentials)
  end

  def create_project_in_reports_service
    CreateProjectInReportsService.new(project).call
    project.save
  rescue ReportsServiceError => e
    project.errors.add(:name, e.message)
  end

  def create_sample_project
    CreateSampleProject.new(project.user).call
  end
end
