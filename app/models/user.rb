require 'bcrypt'

class User < ApplicationRecord

  validates :username, presence: true
  validates :password, length: { minimum: 6 , allow_nil: true }
  validates :password_digest, presence: { message: "Password can't be blank" }

  after_initialize :ensure_session_token

  def generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def reset_session_token!
    self.session_token = generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    pw_obj = BCrypt::Password.create(password)
    self.password_digest = pw_obj.to_s
    self.password = password
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if !user
    user.is_password?(password) ? user : nil
  end

end
