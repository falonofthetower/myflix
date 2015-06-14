class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "#{@video.title} successfully saved!"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Check error messages!"
      render :new
    end
  end

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You don't have authorization to do that"
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit(
      :title,
      :description,
      :small_cover,
      :large_cover,
      :category_id,
      :video_url
    )
  end
end
