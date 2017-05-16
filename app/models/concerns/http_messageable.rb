# This module contains all shared code between Request and Response
# As HTTP specification names Request/Response as Messages this concern has Messageable name
module HttpMessageable
  extend ActiveSupport::Concern

  included do
    belongs_to :endpoint
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
  end
end
