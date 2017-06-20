class Project < ApplicationRecord
  extend FriendlyId

  belongs_to :user
  has_many :endpoints
  has_many :groups
  has_many :documents

  validates :name,
            :app_id,
            :app_secret,
            presence: true

  validates :name, uniqueness: { scope: [:user_id] }

  validates :base_url, url: true, allow_nil: true

  scope :samples,
        -> { where(sample: true) }

  friendly_id :name, use: :slugged
end
