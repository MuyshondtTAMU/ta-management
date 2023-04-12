class Student < ApplicationRecord
    # validates :name, presence: true, format: { with: /([\w\-\']{2,})([\s]+)([\w\-\']{2,})/ }
    validates :uin, presence: true, length: { is: 9 }, format: { with: /\A[0-9]*\z/ }
    :attr_accessor
    has_many :subjects
    belongs_to :user
    # belongs_to :professor

    email_regex = /\A[\w+\-.]+@tamu\.edu\z/i
    # validates :email_id, :presence => true,
    #               :format   => { :with => email_regex },
    #               :uniqueness => { :case_sensitive => false }

    validates :resume, :presence => true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
    validates :transcript, :presence => true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end