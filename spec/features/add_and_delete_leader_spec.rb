require 'spec_helper'

feature "user follows another user" do
  scenario "user follows another user and then deletes following" do
    space_opera  = Fabricate(:category)
    star_wars    = Fabricate(:video, title: "A New Hope", category: space_opera)
    another_user = Fabricate(:user)

    Fabricate(:review, video: star_wars, user: another_user)

    user_sign_in
    click_on_video_on_home_page(star_wars)

    click_link another_user.full_name
    click_link "Follow"
    expect(page).to have_content(another_user.full_name)

    unfollow
    expect(page).not_to have_content(another_user.full_name)
  end

  def unfollow
    find("a[data-method='delete']").click
  end
end
