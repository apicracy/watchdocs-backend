class GroupSerializer < ActiveModel::Serializer
  attributes :id,
             :project_id,
             :group_id,
             :name,
             :description,
             :created_at,
             :updated_at
end
