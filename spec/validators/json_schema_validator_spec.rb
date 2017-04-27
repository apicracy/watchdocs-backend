require 'rails_helper'

RSpec.describe JsonSchemaValidator do
  subject(:validator) { described_class.new }
  let(:record) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :json_schema
      validates :json_schema, json_schema: true
    end.new
  end

  describe '#validate_each' do
    context 'when given schema is invalid' do
      before do
        record.json_schema = { type: 'hekelemekele' }
        record.validate
      end

      it 'makes the object invalid' do
        expect(record).not_to be_valid
      end

      it 'adds detailed json schema validation error' do
        expect(record.errors[:json_schema].first).to eq("json-schema is invalid: The property '#/type' of type string did not match one or more of the required schemas")
      end
    end

    context 'when given schema is valid' do
      before do
        record.json_schema = { type: 'object', required: ['some'] }
        record.validate
      end

      it 'makes the object valid' do
        expect(record).to be_valid
      end
    end
  end
end
