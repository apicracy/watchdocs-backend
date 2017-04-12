RSpec.shared_examples 'unauthorized request' do
  it 'returns unathorized status' do
    expect(response.status).to eq 401
  end
end
