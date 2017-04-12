class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :base_url, :updated_at
end
