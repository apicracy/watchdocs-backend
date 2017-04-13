class Group < ApplicationRecord
  belongs_to :project
  belongs_to :group

  has_many :endpoints
  has_many :groups
end
