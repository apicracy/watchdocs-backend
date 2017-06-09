class ActiveCampaignTracking
  API_ENDPOINT = ENV['ACTIVE_CAMPAIGN_API_ENDPOINT']
  API_KEY = ENV['ACTIVE_CAMPAIGN_API_KEY']
  TRACKING_ACCOUNT_ID = ENV['ACTIVE_CAMPAIGN_TRACKING_ACCOUNT_ID']
  TRACKING_EVENT_KEY = ENV['ACTIVE_CAMPAIGN_TRACKING_EVENT_KEY']
  CONTACT_LIST_ID = ENV['ACTIVE_CAMPAIGN_CONTACT_LIST_ID']

  attr_reader :api, :email

  def self.for(email)
    new email
  end

  def initialize(email)
    @email = email
    @api = ActiveCampaign.new(
      api_endpoint: API_ENDPOINT,
      api_key: API_KEY
    )
  end

  def create_event(event, data: nil)
    return unless email
    api.track_event_add(
      actid: TRACKING_ACCOUNT_ID,
      key: TRACKING_EVENT_KEY,
      email: email,
      event: event,
      eventdata: data
    )
  end

  def add_to_contacts
    return unless email
    api.contact_add(
      email: email,
      "p[#{CONTACT_LIST_ID}]" => CONTACT_LIST_ID
    )
  end
end
