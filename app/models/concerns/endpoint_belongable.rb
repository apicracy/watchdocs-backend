module EndpointBelongable
  extend ActiveSupport::Concern

  included do
    validates :endpoint,
              presence: true

    belongs_to :endpoint
  end

  delegate :user, to: :endpoint
end
