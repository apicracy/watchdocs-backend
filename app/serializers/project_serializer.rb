class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :base_url, :updated_at,
             :app_id, :app_secret, :sample
end
