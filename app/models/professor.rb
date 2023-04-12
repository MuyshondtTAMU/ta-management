class Professor < ApplicationRecord
  :attr_accessor
  belongs_to :user
  # has_many :students
end
