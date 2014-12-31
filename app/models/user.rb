# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  remember_digest :string
#  admin           :boolean          default("f")
#

class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_blank: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistant session
  # This method updates the value of remember_digest column in the db associated with the entered user
  # to the digest of newly generated random string (token)
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Updates remember digest (which is on server) to nil
  def forget
    update_attribute(:remember_digest, nil)
  end

  # First converts remember_token to digest and confirms if the token 
  # is same as the digest
  # returns true if remember token's digest is same as the digest supplied 
  # else false
  def authenticated?(remember_token)
    !remember_digest.nil? ? BCrypt::Password.new(remember_digest).is_password?(remember_token) : false
  end
end
