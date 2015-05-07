require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }

  describe "#queued_video?" do
    it "should return if the item is in the queue" do
      luke = Fabricate(:user)
      star_wars = Fabricate(:video)
      Fabricate(:queue_item, video: star_wars, user: luke)
      luke.queued_item?(star_wars).should be_truthy
    end

    it "should return false if the item is not in the queue" do
      luke = Fabricate(:user)
      star_wars = Fabricate(:video)
      luke.queued_item?(star_wars).should be_falsey
    end
  end
end
