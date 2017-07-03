class User < ApplicationRecord
  has_many :projects

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :jwt_authenticatable,
         :validatable,
         jwt_revocation_strategy: JWTBlacklist
end
