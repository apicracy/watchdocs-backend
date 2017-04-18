Fabricator(:request) do
  headers(count: 1, inverse_of: :headerable)
end
