require 'spec_helper'

feature "user signs in" do
  let(:user) { Fabricate(:user) }

  scenario "signs user in" do
    luke = Fabricate(:user)
    user_sign_in(luke)
    expect(page).to have_content 'You have logged in'
  end
end
