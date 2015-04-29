require 'spec_helper'

describe Category do
  it "saves itself" do
    first_category = Category.create(name: "The category of love")
    first_category.save
    expect(Category.first).to eq(first_category)
  end

  it { should have_many(:videos) }
  it { should validate_presence_of :name }

end
describe "#recent_videos" do

  it "recent_video should return them in reverse chronological order" do
    category = Category.create(name: "The wrong category")

    first_video = Video.create(title: "The first title", description: "The first description", category: category, created_at: 1.day.ago)
    second_video = Video.create(title: "The second title", description: "The second description", category: category)

    expect(category.recent_videos).to eq([second_video, first_video]) 
  end 
  it "recent_videos returns all if there less than six" do
    category = Category.create(name: "The wrong category")
    first_video = Video.create(title: "The first title", description: "The first description", category: category)
    second_video = Video.create(title: "The second title", description: "The second description", category: category)
    expect(category.recent_videos.count).to eq(2)
  end

  it "recent_videos returns just six if there are more than six" do
    category = Category.create(name: "The wrong category")
    7.times {Video.create(title: "foo", category: category, description: "bar")}
    expect(category.recent_videos.count).to eq(6)
  end

  it "returns the most 6 recent videos" do
    category = Category.create(name: "The wrong category")
    6.times {Video.create(title: "foo", category: category, description: "bar")}
    tonights_movie = Video.create(title: "Tonights Movie", description: "Yesterday's show", created_at: 1.day.ago)
    expect(category.recent_videos).not_to include(tonights_movie)
  end


  it "returns empty array if the category does not have any videos" do
    category = Category.create(name: "The wrong category")
    expect(category.recent_videos).to eq([])
  end

end
