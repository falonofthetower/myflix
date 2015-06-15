require "spec_helper"

feature "Admin adds video" do
  scenario "admin successfully adds video and user views it" do
    Fabricate(:category, name: "Anime")
    admin_sign_in

    visit new_admin_video_path
    fill_in "Title", with: "Attack on Titan"
    select "Anime", from: "Category"
    fill_in "Description", with:
      "After his hometown is destroyed and his mother is killed, \
      young Eren Jaegar vows to cleanse the earth of the giant humanoid \
      Titans that have brought humanity to the brink of extinction."
    attach_file "Large Cover", Rails.root + "public/tmp/castle_large.jpg"
    attach_file "Small Cover", Rails.root + "public/tmp/castle.jpg"
    fill_in "Video URL", with: "https://example.com/video.mp4"
    click_button "Add Video"

    sign_out
    user_sign_in

    video = Video.find_by_title "Attack on Titan"

    find("a[href='/videos/#{video.id}']").click
    expect(page).to have_selector("img[src='/uploads/castle_large.jpg']")
    expect(page).to have_selector("a[href='https://example.com/video.mp4']")
  end
end
