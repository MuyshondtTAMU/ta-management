class User < ApplicationRecord
  
  after_create :create_associated_record
  
  has_one :student
  has_one :professor
  has_one :management
  has_many :assignments


    before_save { self.email_id = email_id.downcase }

    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email_id, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
    
    validates :access_level, presence: false
      # Exclude access_level from validation
    # attr_accessor :confirm_password, :name, :email_id
    
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
  
  private
      
    def create_associated_record
      case access_level
      # when 'TA'
      #   Student.create(user: self)
      when 'Professor'
        Professor.create(user: self)
      when 'Coordinator'
        Management.create(user: self)
      when 'Hiring Manager'
        Management.create(user: self)
      end
    end
  
end
