class ApiCredentials
  class << self
    def generate(name)
      return unless name.present?
      {
        app_id: generate_app_id(name),
        app_secret: generate_app_secret
      }
    end

    private

    def generate_app_id(name)
      name.gsub(/[^a-zA-Z\d]/, '')
          .upcase +
          Faker::Number.hexadecimal(5)
    end

    def generate_app_secret
      Faker::Bitcoin.testnet_address
    end
  end
end
