require 'spec_helper'

describe Category do
  it "saves itself" do
    first_category = Category.create name: "The category of love"
    first_category.save
    expect(Category.first).to eq first_category
  end

  it "has many videos" do
    dramas = Category.create name: "drama"
    monk = Video.create title: "Monk", description: "Dective show", category: dramas
    south_park = Video.create title: "South Park", description: "Cartoon", category: dramas
    expect(dramas.videos).to include monk, south_park
  end
end
