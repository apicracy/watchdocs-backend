require 'rails_helper'

RSpec.describe OverrideDraft do
  context 'original and draft already exists' do
    let(:response) do
      Response.new(body: 'test', body_draft: 'test2')
    end

    before do
      described_class.new(response, body: 'test3').call
    end

    it 'clears draft column' do
      expect(response.body_draft).to be_nil
    end

    it 'updates original column with new value' do
      expect(response.body).to eq('test3')
    end
  end
end
