require "spec_helper"

feature "user invites another user and they sign up" do
  scenario "user sends invite, invitee signs up", :js, :vcr do
    morpheus = Fabricate(:user)
    neo = Fabricate.build(:user)

    user_sign_in morpheus

    send_invitation_to neo
    accept_invitation neo

    visit sign_in_path
    fill_in "Email Address", with: neo.email
    fill_in "Password", with: neo.password
    click_button "Sign in"

    check_for_following morpheus

    visit sign_out_path
    user_sign_in morpheus
    check_for_following neo
  end

  def create_friend_through_invitation(friend)
    invite_a_friend friend
    invited_user_signs_up friend
  end

  def send_invitation_to(friend)
    visit new_invitation_path
    fill_in "Friend's Name", with: friend.full_name
    fill_in "Friend's Email Address", with: friend.email
    fill_in(
      "Invitation Message",
      with: "This is your last chance. After this, there is no turning back. \
    You take the blue pill - the story ends, you wake up in your bed and \
    believe whatever you want to believe. You take the red pill\
    - you stay in Wonderland and I show you how deep the rabbit-hole goes."
    )
    click_button "Send Invitation"
    visit sign_out_path
  end

  def accept_invitation(user)
    open_email(user.email)
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: user.password
    fill_in "Full Name", with: user.full_name
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select 1.year.from_now.year, from: "date_year"
    click_button "Sign Up"
    expect(page).to have_css(".alert-success")
  end

  def check_for_following(other_user)
    visit people_path
    expect(page).to have_content(other_user.full_name)
  end
end
