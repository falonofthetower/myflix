require 'spec_helper'

describe Video do
  it "saves itself" do
   first_video = Video.create title: "The first title", description: "The first description"
   first_video.save
   expect(Video.first).to eq(first_video)
  end

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end


