def set_current_user(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def current_user
  User.find(session[:user_id])
end

def with_a_luke_and_a_new_hope
  let(:a_new_hope) { Fabricate(:video) }
  let(:luke) { Fabricate(:user) }
end

def user_sign_in(user = nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in 'Email Address', :with => user.email
  fill_in 'Password', :with => user.password
  click_button 'Sign in'
end
