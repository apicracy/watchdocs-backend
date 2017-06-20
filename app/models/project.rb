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

  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, :sequence],
      [:name, :sequence, :id]
    ]
  end

  private

  def should_generate_new_friendly_id?
    name_changed?
  end

  def sequence
    self.class.where(name: name).count
  end
end
