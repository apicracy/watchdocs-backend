RSpec.shared_examples 'unauthorized request' do
  it 'returns unathorized status' do
    expect(response.status).to eq 401
  end
end

RSpec.shared_examples 'authorized request' do
  it 'returns unathorized status' do
    expect(response.status).not_to eq 401
  end
end
