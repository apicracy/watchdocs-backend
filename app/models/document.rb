class Document < ApplicationRecord
  include Groupable

  validates :name, :project, presence: true
end
