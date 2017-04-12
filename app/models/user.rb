class User < ApplicationRecord
  has_many :projects

  devise :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist
end
