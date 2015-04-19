require 'spec_helper'

describe Category do
  it "saves itself" do
    first_category = Category.create(name: "The category of love")
    first_category.save
    expect(Category.first).to eq(first_category)
  end

  it { should have_many(:videos) }
end
