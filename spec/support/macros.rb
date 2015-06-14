def set_current_user(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_out
  visit sign_out_path
end

def current_user
  User.find(session[:user_id])
end

def set_current_admin(admin = nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def with_a_luke_and_a_new_hope
  let(:a_new_hope) { Fabricate(:video) }
  let(:luke) { Fabricate(:user) }
end

def user_sign_in(user = nil, password = nil)
  user ||= Fabricate(:user)
  password ||= user.password
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: password
  click_button 'Sign in'
end
