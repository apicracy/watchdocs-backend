class User < ApplicationRecord
  has_many :projects

  validates :email, uniqueness: true
  validates :password, confirmation: true, on: :update

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist
end
