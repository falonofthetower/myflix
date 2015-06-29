class Admin::VideosController < AdminController
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
      flash.now[:danger] = "Check error messages!"
      render :new
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
