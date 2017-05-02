class Group < ApplicationRecord
  include Groupable

  has_many :endpoints, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :groups, dependent: :destroy

  validates :name, :project, presence: true
end
