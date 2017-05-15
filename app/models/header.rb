class Header < ApplicationRecord
  belongs_to :headerable,
             polymorphic: true,
             inverse_of: :headers,
             touch: true

  validates :key,
            presence: true,
            uniqueness: { scope: [:headerable_id, :headerable_type] }

  validates :headerable, presence: true
  validates :required, presence: true

  delegate :user, to: :headerable
end
