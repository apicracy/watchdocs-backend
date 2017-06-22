Fabricator(:group) do
  project
  name { Faker::Lorem.word }
  description { Faker::Lorem.paragraph }
  tree_item(inverse_of: :itemable) do |attrs|
    Fabricate(
      :tree_item,
      parent_id: attrs[:group]&.tree_item&.id ||
                  attrs[:project]&.tree_root&.id
    )
  end
end
