# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default("f")
#  activation_digest :string
#  activated         :boolean          default("f")
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#

class User < ActiveRecord::Base
  
  has_many :active_relationships, class_name:     "Relationship",
                                  foreign_key:    "follower_id",
                                  dependent:      :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name:     "Relationship",
                                  foreign_key:    "followed_id",
                                  dependent:      :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  # dependent: :destroy enables auto deletion of microposts upon deletion of user
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { self.email = email.downcase }
  before_create :create_activation_digest

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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # create_activation_digest is a method reference and
  # it is executed before creation of user
  # purpose - assign an activation token and an activation digest to the corresponding user
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # sends email to user requesting password reset
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # gives a list of all the feeds associated with the user
  def feed
    Micropost.where("user_id= ?", id)

    ## can also be written as follows
    # microposts
  end

  # follow other user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # unfollow other user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

  # Returns a user's status feed.
  def feed
    # RAW-SQL        followed_ids returns all the people user follows
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

end