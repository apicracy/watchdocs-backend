require 'rails_helper'

RSpec.describe SubmitDraft do
  let(:draftable_object) do
    Response.new(body: 'test', body_draft: 'test2')
  end

  context 'original and draft already exists' do
    before do
      described_class.new(draftable_object, body: 'test3').call
    end

    it 'overrides already existing draft' do
      expect(draftable_object.body_draft).to eq('test3')
    end

    it 'doest not change original value' do
      expect(draftable_object.body).to eq('test')
    end
  end

  context 'original and draft do not yet exists' do
    let(:draftable_object) do
      Response.new
    end

    before do
      described_class.new(draftable_object, body: 'test3').call
    end

    it 'does not save anything to draft column' do
      expect(draftable_object.body_draft).to be_nil
    end

    it 'saves directly to original column' do
      expect(draftable_object.body).to eq('test3')
    end
  end

  context 'draft not yet exists' do
    let(:response) do
      Response.new(body: 'test')
    end

    before do
      described_class.new(response, body: 'test3').call
    end

    it 'saves new value to draft column' do
      expect(response.body_draft).to eq('test3')
    end

    it 'doest not change original value' do
      expect(response.body).to eq('test')
    end
  end

  context 'new draft is the same as original' do
    let(:draftable_object) do
      Response.new body: 'test'
    end

    before do
      described_class.new(draftable_object, body: 'test').call
    end

    it 'does not save anything to draft column' do
      expect(draftable_object.body_draft).to be_nil
    end
  end

  it 'saves object at the end' do
    allow(draftable_object).to receive(:save)
    described_class.new(draftable_object, {}).call
    expect(draftable_object).to have_received(:save).once
  end
end
