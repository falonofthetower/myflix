require 'spec_helper'

describe Video do
  it "saves itself" do
   first_video = Video.create title: "The first title", description: "The first description"
   first_video.save
   expect(Video.first).to eq first_video
  end

  it "belongs to category" do
    dramas = Category.create name: "dramas"
    monk = Video.create title: "Monk", description: "Dective show", category: dramas
    expect(monk.category).to eq dramas
  end
end


