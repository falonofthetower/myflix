class User < ActiveRecord::Base
  has_many :queue_items, -> { order(:position) }
  has_many :reviews, -> { order("created_at DESC") }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email

  has_secure_password validations: false

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_item?(item)
    queue_items.map(&:video).include?(item)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self == another_user || self.follows?(another_user))
  end

  def tokenize
    self.update_column(:token, generate_token)
  end

  def generate_token
    SecureRandom.urlsafe_base64
  end

  def destroy_token
    self.update_column(:token, nil)
  end
end
