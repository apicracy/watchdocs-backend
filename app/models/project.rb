class Project < ApplicationRecord
  belongs_to :user
  has_many :endpoints
  has_many :groups
  has_many :documents

  validates :name,
            :base_url,
            :app_id,
            :app_secret,
            presence: true

  validates :base_url, url: true

  before_validation :generate_api_credentials,
                    :create_project_in_reports_service,
                    on: :create

  private

  def generate_api_credentials
    credentials = ApiCredentials.generate(name)
    return unless credentials
    assign_attributes(credentials)
  end

  def create_project_in_reports_service
    CreateProjectInReportsService.new(self).call
  rescue ReportsServiceError => e
    errors.add(:name, e.message)
  end
end
