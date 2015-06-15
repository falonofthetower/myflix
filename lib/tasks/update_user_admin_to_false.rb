desc "Updates admin column in current users to false"
task :set_admin_to_false do
  User.all.each do |user|
    if user.admin == nil
      user.update_attribute :admin, false
    end
  end
end
