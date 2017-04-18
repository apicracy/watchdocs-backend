class HeaderSerializer < ActiveModel::Serializer
  attributes :id, :key, :required, :description, :example_value, :status
end
