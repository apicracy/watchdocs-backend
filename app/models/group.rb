class Group < ApplicationRecord
  belongs_to :project
  belongs_to :group
end
