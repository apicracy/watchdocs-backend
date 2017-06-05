class CreateGroupName
  attr_reader :url
  VERSION_REGEX = /v[0-9]/
  API_REGEX = /api/

  def initialize(url:)
    @url = url
  end

  def parse_url
    candidates = url.split('/')
    candidates = candidates.reject(&:blank?) # Reject blank
    candidates = candidates.reject { |c| c.match API_REGEX } # Reject API parts
    candidates = candidates.reject { |c| c.match VERSION_REGEX } # Rejects version numbers

    return candidates.first.humanize if candidates.length.positive?
    'Other'
  end
end
