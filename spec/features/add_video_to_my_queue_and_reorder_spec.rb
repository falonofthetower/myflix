require 'spec_helper'

feature "user fills and reorders queue" do
  scenario "user adds and reorders videos in the queue" do
    space_opera = Fabricate(:category)
    star_wars = Fabricate(:video, title: "A New Hope", category: space_opera)
    empire = Fabricate(:video, title: "The Empire Strikes Back", category: space_opera)
    return_of_the_jedi = Fabricate(:video, title: "Return of the Jedi", category: space_opera)
    user_sign_in

    add_video_to_queue(star_wars)
    should_contain_video(star_wars)

    visit video_path(star_wars)
    should_not_have_link("+ My Queue")

    add_video_to_queue(empire)
    add_video_to_queue(return_of_the_jedi)

    set_video_position(star_wars, 2)
    set_video_position(empire, 3)
    set_video_position(return_of_the_jedi, 1)

    update_queue

    expect_video_position(star_wars, 2)
    expect_video_position(empire, 3)
    expect_video_position(return_of_the_jedi, 1)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    find_link("+ My Queue").click
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end

  def update_queue
    click_button("Update Instant Queue")
  end

  def should_not_have_link(link_text)
    page.should_not have_content(link_text)
  end

  def should_contain_video(video)
    page.should have_content(video.title)
  end
end
