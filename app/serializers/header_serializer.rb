class HeaderSerializer < ActiveModel::Serializer
  attributes :id,
             :headerable_id,
             :headerable_type,
             :key,
             :required,
             :description,
             :example_value
end
