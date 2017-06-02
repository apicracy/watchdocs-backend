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

  def generate_api_credentials
    return true if app_id && app_secret
    credentials = ApiCredentials.generate(name)
    return unless credentials
    assign_attributes(credentials)
  end
end
