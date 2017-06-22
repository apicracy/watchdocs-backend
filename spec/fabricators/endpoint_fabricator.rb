Fabricator(:endpoint) do
  project
  http_method { Endpoint::METHODS.first }
  url { "/#{Faker::Lorem.word}/#{Faker::Lorem.word}/:id" }
  status { Endpoint.statuses[:up_to_date] }
  title { Faker::Lorem.sentence }
  summary { Faker::Lorem.paragraph }
  tree_item(inverse_of: :itemable) do |attrs|
    Fabricate(
      :tree_item,
      parent_id: attrs[:group]&.tree_item&.id ||
                  attrs[:project]&.tree_root&.id
    )
  end
end

Fabricator(:full_endpoint, from: :endpoint) do
  responses(count: 1)
  url_params(count: 1)
end
