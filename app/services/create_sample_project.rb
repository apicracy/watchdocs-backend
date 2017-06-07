class CreateSampleProject
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    return unless sample_project_needed?
    project = Fabricate(:project, sample: true)
    login_group = Fabricate(:group, project: project, name: 'Authentication')
    Fabricate(:full_endpoint, project: project, group: login_group)
  end

  private

  def sample_project_needed?
    user.projects.count == 1
  end
end
