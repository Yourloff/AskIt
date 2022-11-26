# frozen_string_literal: true

# Модель пользователя
class User < ApplicationRecord
  attr_accessor :old_password, :remember_token

  has_secure_password
  has_secure_password :recovery_password, validations: false

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? }
  validates :email, presence: true, uniqueness: true, 'valid_email2/email': true
  validates :password, confirmation: true, allow_blank: true, length: { minimum: 8, maximum: 70 }
  validate :password_complexity

  before_save :set_gravatar_hash, if: :email_changed?

  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64
    update_column :remember_token_digest, digest(remember_token)
  end

  def forget_me
    update_column :remember_token_digest, nil
    self.remember_token = nil
  end

  def remember_token_authenticated?(remember_token)
    return false unless remember_token_digest.present?

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
  end

  private

  def set_gravatar_hash
    return unless email.present?

    email_hash = Digest::MD5.hexdigest email.strip.downcase
    self.gravatar_hash = email_hash
  end

  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

  def password_presence
    errors.add(:password, :blank) unless password_digest.present?
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password,
               'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase,'\
                    '1 lowercase, 1 digit and 1 special character'
  end
end
