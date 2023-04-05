class User < ApplicationRecord

    before_save { self.email_id = email_id.downcase }

    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email_id, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
    
    validates :access_level, presence: true
    # attr_accessor :confirm_password, :name, :email_id
<<<<<<< HEAD

=======
    
>>>>>>> 16a214d96d34f6c157c4d3d4b6d369e870a85495
    validate :valid_password, on: :create
    has_secure_password
    validates :password, presence: true,length: { minimum: 6 }, on: :create
    
  def valid_password
    if password_confirmation.blank?
      errors.add(:password_confirmation, 'must not be blank')
    end

    if password != password_confirmation
      errors.add(:password, 'and confirm password do not match')
    end
  end
end