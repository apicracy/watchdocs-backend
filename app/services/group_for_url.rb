class GroupForUrl
  attr_reader :url

  def initialize(url:)
    @url = url
  end

  def call
    parse_url
  end

  private

  def version
    /v[0-9]/
  end

  def api
    /api/
  end

  def parse_url
    candidates = url.split('/')
    candidates = candidates.reject(&:blank?) # Reject blank
    candidates = candidates.reject { |c| c.match api } # Reject API parts
    candidates = candidates.reject { |c| c.match version } # Rejects version numbers

    if candidates.length > 0
      return candidates.first.humanize
    else
      return 'Other'
    end
  end
end
