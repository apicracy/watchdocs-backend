# This module contains all shared code between Request and Response
# As HTTP specification names Request/Response as Messages this concern has Messageable name
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

    before_save :normalize_json_schemas
    before_save :cleanup_unnecessary_draft
    before_save :set_status
  end

  private

  def normalize_json_schemas
    self.body = JsonSchemaNormalizer.new(body).normalize if body_changed? && body
    self.body_draft = JsonSchemaNormalizer.new(body_draft).normalize if body_draft_changed? && body_draft
  end

  def cleanup_unnecessary_draft
    self.body = body_draft unless body.present?
    self.body_draft = nil if body_draft == body
  end

  def set_status
    self.status = body_draft.present? ? :outdated : :up_to_date
  end
end
