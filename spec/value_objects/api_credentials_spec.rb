require 'rails_helper'

RSpec.describe ApiCredentials do
  describe '.generate' do
    subject(:credentials) { described_class.generate(name) }

    context 'when name is not empty' do
      let(:name) { 'Watchdocs-Total89! Ltd.' }

      it 'generates app_id based on given name' do
        expect(credentials[:app_id]).to include('WATCHDOCSTOTAL89LTD')
      end

      it 'generates secret_id' do
        expect(credentials[:app_secret]).to be_present
      end
    end

    context 'when name is empty' do
      let(:name) { nil }

      it 'returns nil' do
        expect(credentials).to be_nil
      end
    end
  end
end
