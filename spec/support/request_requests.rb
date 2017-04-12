module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
    def clear_json
      @json = nil
    end
  end

  module XmlHelpers
    def xml
      @xml ||= Nokogiri::XML::Document.parse(response.body)
    end
  end
end
