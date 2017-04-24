class UrlParamSerializer < ActiveModel::Serializer
  attributes :id,
             :description,
             :is_part_of_url,
             :data_type,
             :endpoint_id,
             :name,
             :example
end
