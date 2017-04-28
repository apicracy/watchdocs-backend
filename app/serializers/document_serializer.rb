class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :group_id, :name, :text, :created_at, :updated_at
end
