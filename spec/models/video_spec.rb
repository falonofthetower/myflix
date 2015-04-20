require 'spec_helper'

describe Video do
  it "saves itself" do
   first_video = Video.create(title: "The first title", description: "The first description")
   first_video.save
   expect(Video.first).to eq(first_video)
  end

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it "returns search by title by title" do
   first_video = Video.create(title: "The first title", description: "The first description")
   second_video = Video.create(title: "The second title", description: "The second description")
   expect(Video.search_by_title("hello").to eq([])
  end

  it "should return a single item on a partial match"
   first_video = Video.create(title: "The first title", description: "The first description")
   second_video = Video.create(title: "The second title", description: "The second description")
   expect(Video.search_by_title("first").to eq([first_video])

  it "should return a single item on a full match"
   first_video = Video.create(title: "The first title", description: "The first description")
   second_video = Video.create(title: "The second title", description: "The second description")
   expect(Video.search_by_title("The first title"). to eq([first_video])

  it "should return an array on a multi-partial match"
   first_video = Video.create(title: "The first title", description: "The first description")
   second_video = Video.create(title: "The second title", description: "The second description")
   expect(Video.search_by_title("title").to eq([first_video, second_video]) 
  end
end


