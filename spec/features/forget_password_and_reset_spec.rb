require 'spec_helper'

feature "user forgets and resets password" do
  let(:neo) { Fabricate(:user, password: "old_password") }

  scenario "user resets password, then attempts to do so again" do
    neo = Fabricate(:user, password: "old_password")

    submit_forgot_password_request neo

    visit_password_reset_link neo

    change_password "new_password"

    user_sign_in neo, "new_password"
    expect(page).to have_content("You have logged in")

    visit_password_reset_link neo
    expect(page).to have_content("expired")
  end

  def submit_forgot_password_request(user)
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in 'Email Address', with: user.email
    click_button 'Send Email'
  end

  def change_password(password)
    fill_in 'New Password', with: password
    click_button 'Reset Password'
  end

  def retrieve_reset_link
    open_email(user.email)
    current_email
  end

  def visit_password_reset_link(user)
    open_email(user.email)
    current_email.click_link "Reset Password"
  end
end
