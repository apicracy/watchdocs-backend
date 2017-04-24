class UrlParamSerializer < ActiveModel::Serializer
  attributes :id,
             :description,
             :is_part_of_url,
             :data_type,
             :endpoint_id

  attribute :key, key: :name
  attribute :example_value, key: :example
end
