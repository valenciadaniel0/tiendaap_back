class User < ApplicationRecord
  acts_as_token_authenticatable

  ROLES = HashWithIndifferentAccess.new({ admin: 1, store: 2 })

  has_many :products

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
    role == ROLES[:admin]
  end
end
