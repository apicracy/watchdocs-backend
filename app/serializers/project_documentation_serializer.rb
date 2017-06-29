class ProjectDocumentationSerializer < AbstractTreeSerializer
  attributes :id, :documentation, :base_url, :user_id, :name

  def documentation
    serialize_tree(generate_tree)
  end

  private

  def serialize_endpoint(endpoint)
    EndpointItem.new(endpoint).as_json
  end

  class EndpointItem < ActiveModel::Serializer
    attributes :url,
               :status,
               :description

    attribute :http_method, key: :method

    has_one :request
    has_many :responses
    has_many :url_params

    def responses
      object.responses.order(:http_status_code)
    end
  end
end
