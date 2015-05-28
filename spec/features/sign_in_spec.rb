require 'spec_helper'

describe "the signin process" do
  it "signs user in" do
    luke = Fabricate(:user)
    visit 'sign_in'
    user_sign_in luke
    expect(page).to have_content 'You have logged in'
  end
end
