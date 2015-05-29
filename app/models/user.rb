class User < ActiveRecord::Base
  has_many :queue_items, -> { order(:position) }
  has_many :reviews, -> { order("created_at DESC") }
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
end
