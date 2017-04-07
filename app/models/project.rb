class Project < ApplicationRecord
  belongs_to :user
  has_many :endpoints
  has_many :groups
end
