Fabricator(:endpoint) do
  method { Endpoint::METHODS.first }
  url { '/contributions' }
end
