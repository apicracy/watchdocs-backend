class Project < ApplicationRecord
  extend FriendlyId

  belongs_to :user
  has_many :endpoints, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_one :tree_root,
          class_name: TreeItem,
          dependent: :destroy

  validates :name,
            :app_id,
            :app_secret,
            presence: true

  validates :name, uniqueness: { scope: [:user_id] }

  validates :base_url, url: true, allow_nil: true

  scope :samples,
        -> { where(sample: true) }

  friendly_id :slug_candidates, use: [:slugged]

  before_validation :build_tree_root, on: :create, unless: :tree_root

  def slug_candidates
    [
      :name,
      [:name, :sequence],
      [:name, :sequence, :id]
    ]
  end

  def top_level_groups
    groups.includes(:tree_item)
          .where(tree_items: { parent_id: tree_root.id })
  end

  private

  def should_generate_new_friendly_id?
    name_changed?
  end

  def sequence
    self.class.where(name: name).count
  end
end
