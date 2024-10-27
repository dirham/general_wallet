require "openssl"

class User < ApplicationRecord
  attr_accessor :password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  before_save :hash_password

  # belongs_to :wallet, optional: true
  has_one :wallet, as: :owner

  def authenticate(input_password)
    hmac_password(input_password) == self.password_digest
  end

  private

  def hmac_password(password)
    secret_key = Rails.application.secret_key_base
    OpenSSL::HMAC.hexdigest("SHA256", secret_key, password)
  end

  def hash_password
    if password.present?
      self.password_digest = hmac_password(password)
    end
  end
end
