require "spec_helper"

describe "the signin process" do
  it "signs active user in" do
    luke = Fabricate(:user, active: true)
    visit "sign_in"
    user_sign_in luke
    expect(page).to have_content "You have logged in"
  end

  it "fails to sign in deactivated user" do
    luke = Fabricate(:user, active: false)
    visit "sign_in"
    user_sign_in luke
    expect(page).to have_content("Your account has been suspended")
  end
end
