module Projects
  class FetchEndpoint
    attr_reader :endpoint_id

    def initialize(endpoint_id)
      @endpoint_id = endpoint_id
    end

    def call
      ::Endpoint.find(endpoint_id)
    end
  end
end
