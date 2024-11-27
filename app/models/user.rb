class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email

  has_many :posts

  def as_json(options = nil, excluded_keys = [ :password_digest ])
    super(options).except(*excluded_keys.map(&:to_s))
  end
end
