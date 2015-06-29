require "spec_helper"

feature "Admin sees payment" do
  background do
    luke = Fabricate(:user, full_name: "Luke Skywalker", email: "luke@rebel_alliance.com")
    Fabricate(:payment, amount: "999", user: luke)
  end

  scenario "admin can see payment" do
    admin_sign_in
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Luke Skywalker")
    expect(page).to have_content("luke@rebel_alliance.com")
  end

  scenario "user cannot see payment" do
    user_sign_in
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Luke Skywalker")
    expect(page).to have_content("You don't have authorization to do that")
  end
end
