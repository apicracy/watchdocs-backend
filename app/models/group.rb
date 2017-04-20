class Group < ApplicationRecord
  include Groupable

  has_many :endpoints
  has_many :groups
  has_many :documents
end
