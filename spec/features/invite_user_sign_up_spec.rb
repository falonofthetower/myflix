require "spec_helper"

feature "user invites another user and they sign up" do
  scenario "user sends invite, invitee signs up" do
    morpheus = Fabricate(:user)
    neo = Fabricate.build(:user)

    user_sign_in morpheus

    send_invitation_to neo
    accept_invitation neo

    user_sign_in neo
    check_for_following morpheus

    sign_out
    user_sign_in morpheus
    check_for_following neo
  end

  def create_friend_through_invitation(friend)
    invite_a_friend friend
    invited_user_signs_up friend
  end

  def send_invitation_to(friend)
    click_link "Invite friend"
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
    sign_out
  end

  def accept_invitation(user)
    open_email(user.email)
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: user.password
    fill_in "Full Name", with: user.full_name
    click_button "Sign Up"
  end

  def check_for_following(other_user)
    click_link "People"
    expect(page).to have_content(other_user.full_name)
  end
end
