class HeaderSerializer < ActiveModel::Serializer
  attributes :id,
             :headerable_id,
             :headerable_type,
             :key,
             :required,
             :required_draft,
             :description,
             :example_value,
             :status
end
