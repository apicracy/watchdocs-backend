module HttpMessageable
  extend ActiveSupport::Concern

  included do
    belongs_to :endpoint, touch: true
    has_many :headers,
             as: :headerable,
             dependent: :destroy,
             inverse_of: :headerable

    validates :endpoint,
              presence: true

    validates :body,
              :body_draft,
              json_schema: true

    enum status: %i(outdated up_to_date)

    delegate :user, to: :endpoint

    before_save :set_status
    after_touch :set_status
  end

  def set_status
    self.status = body_draft.blank? ? :up_to_date : :outdated
  end
end
