class User < ApplicationRecord
  has_many :projects

  validates :email, uniqueness: true

  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist
end
