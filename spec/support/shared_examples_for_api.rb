RSpec.shared_examples 'unauthorized' do
  it 'returns unathorized status' do
    expect(response.status).to eq 401
  end
end

RSpec.shared_examples 'not found' do
  it 'returns unathorized status' do
    expect(response.status).to eq 404
  end

  it 'returns not found as a description' do
    expect(json["errors"].first["title"]).to eq('Record not found')
  end
end
