require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  let(:first_video) { Fabricate(:video, title: "The first title", description: "The first description", created_at: 1.day.ago) }
  let(:second_video) { Fabricate(:video, title: "The second title", description: "The second description") }

  it "saves itself" do
    first_video.save
    expect(Video.first).to eq(first_video)
  end

  it "returns search by title by title" do
    expect(Video.search_by_title("hello")).to eq([])
  end

  it "should return a single item on a partial match" do
    expect(Video.search_by_title("first")).to eq([first_video])
  end

  it "should return a single item on a full match" do
    expect(Video.search_by_title("The first title")). to eq([first_video])
  end

  it "should return an array of matches ordered by created_at" do
    expect(Video.search_by_title("title")).to eq([second_video, first_video])
  end

  it "should return empty array if search term is blank" do
    expect(Video.search_by_title("")).to eq([])
  end
end
