module UrlPath
  # Url format should be /path/to/endpoint/:param
  # with leading slash and without finishing one
  # allows params starting with ":"
  VALID_PATH = %r(\A\/{1}(:?[A-Za-z0-9\-_\.~]+\/)*(:?[A-Za-z0-9\-_\.~]+)\z)

  def self.autocorect(url)
    corrected = url
    corrected.prepend('/') unless corrected.start_with?('/')
    corrected.chomp!('/') if corrected.end_with?('/')
    corrected
  end
end
