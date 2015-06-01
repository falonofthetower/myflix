module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map {|number| [pluralize(number, "Star"), number]}, selected)
  end

  def gravatar_url_for(email)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=40"
  end
end
