class User < ApplicationRecord
    validates :name, presence: true
    validates :email_id, presence: true
    validates :password, presence: true
    validates :access_level, presence: true
    attr_accessor :password, :confirm_password
    validate :valid_password

  def valid_password
    if confirm_password.blank?
      errors.add(:confirm_password, 'must not be blank')
    end

    if password != confirm_password
      errors.add(:password, 'and confirm password do not match')
    end
  end
end
