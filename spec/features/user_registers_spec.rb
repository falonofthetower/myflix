require "spec_helper"

feature "User registers", js: true, vcr: true do
  background do
    visit register_path
  end

  valid_card_number = "4242 4242 4242 4242"
  declining_card_number = "4000 0000 0000 0002"
  expired_card_number = "4000 0000 0000 0069"

  scenario "with valid card and valid user info" do
    fill_in_valid_user_info
    fill_in_credit_card_info_with valid_card_number
    click_button "Sign Up"
    expect(page).to have_css(".alert-success")
  end

  scenario "with invalid card and valid user input" do
    fill_in_valid_user_info
    fill_in_credit_card_info_with declining_card_number
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end

  scenario "with expired card and valid user input" do
    fill_in_valid_user_info
    fill_in_credit_card_info_with expired_card_number
    click_button "Sign Up"
    expect(page).to have_content("Your card has expired.")
  end

  scenario "with valid card and invalid user info" do
    fill_in_invalid_user_info
    fill_in_credit_card_info_with valid_card_number
    click_button "Sign Up"
    expect(page).to have_content(
      "Invalid user info, please fix highlighted fields"
    )
  end

  scenario "with invalid card and invalid user info" do
    fill_in_invalid_user_info
    fill_in_credit_card_info_with declining_card_number
    click_button "Sign Up"
    expect(page).to have_content(
      "Invalid user info, please fix highlighted fields"
    )
  end

  scenario "with expired card and invalid user info" do
    fill_in_invalid_user_info
    fill_in_credit_card_info_with expired_card_number
    click_button "Sign Up"
    expect(page).to have_content(
      "Invalid user info, please fix highlighted fields"
    )
  end
end

def fill_in_valid_user_info
  user = Fabricate.build(:user)
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  fill_in "Full Name", with: user.full_name
end

def fill_in_invalid_user_info
  fill_in "Email Address", with: "foo@bar.com"
end

def fill_in_credit_card_info_with(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: "123"
  select "7 - July", from: "date_month"
  select 1.year.from_now.year, from: "date_year"
end
