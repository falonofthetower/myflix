require 'spec_helper'

describe Video do
  it "saves itself" do
   first_video = Video.create title: "The first title", description: "The first description"
   first_video.save
   expect(Video.first).to eq first_video
  end
end
