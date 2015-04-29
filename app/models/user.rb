class User < ActiveRecord::Base
  has_many :queue_items
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email

  has_secure_password validations: false
end
