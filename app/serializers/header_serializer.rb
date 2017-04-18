class HeaderSerializer < ActiveModel::Serializer
  attributes :id, :key, :required, :required_draft, :description, :example_value, :status
end
