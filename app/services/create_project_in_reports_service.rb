class CreateProjectInReportsService
  include HTTParty
  base_uri ENV['REPORTS_SERVICE_BASE_URL']
  REPORTS_SERVICE_PROJECTS_PATH = ENV['REPORTS_SERVICE_PROJECTS_PATH']

  API_AUTH = {
    username: ENV['HTTP_AUTH_NAME'],
    password: ENV['HTTP_AUTH_PASSWORD']
  }.freeze

  DEFAULT_ERROR = 'Unknown Reports Service connection error occured.
                  Please contact support!'.freeze

  attr_reader :payload

  def initialize(project)
    @payload = {
      app_id: project.app_id,
      app_secret: project.app_secret
    }
  end

  def call
    response = self.class.post(
      REPORTS_SERVICE_PROJECTS_PATH,
      body: payload.to_json,
      headers: { 'Content-Type' => 'application/json' },
      basic_auth: API_AUTH
    )
    check_response(response)
  rescue StandardError => e
    raise ReportsServiceError, e.message
  end

  private

  # TODO: When service is unavailable we
  # can schedule the task for later
  def check_response(response)
    case response.code.to_s.chars.first
    when '2'
      true
    when '4', '5'
      raise get_error(response.body)
    else
      raise DEFAULT_ERROR
    end
  end

  def get_error(response_body)
    JSON.parse(response_body)['errors']
  rescue
    DEFAULT_ERROR
  end
end
