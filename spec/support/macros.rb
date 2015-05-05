def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def current_user
  User.find(session[:user_id])
end

def with_a_luke_and_a_new_hope
  let(:a_new_hope) { Fabricate(:video) }
  let(:luke) { Fabricate(:user) }
end
