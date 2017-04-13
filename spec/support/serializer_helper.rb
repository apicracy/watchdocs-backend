module SerializerHelper
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :serializer

    def serializer_for(object)
      described_class.new(object)
    end

    def serialized_hash(serializer)
      ActiveModelSerializers::Adapter.create(serializer)
    end

    def serialized_json(serializer)
      serialized_hash(serializer).to_json
    end
  end

  RSpec.configure do |config|
    config.include  self,
                    type: :serializer,
                    file_path: %r{spec/serializers}
  end
end
