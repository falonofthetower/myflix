require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      luke = Fabricate(:user)
      session[:user_id] = luke.id
      light_saber = Fabricate(:queue_item, user: luke)
      r2d2 = Fabricate(:queue_item, user: luke)
      get :index
      expect(assigns(:queue_items)).to match_array([light_saber, r2d2])
    end
    it " redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    
    it "creates the queue item that is associated with the user" do
      luke = Fabricate(:user)
      session[:user_id] = luke.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(luke)
    end

    it "it puts the video as the last item in the queue" do
      luke = Fabricate(:user)
      session[:user_id] = luke.id
      empire = Fabricate(:video)
      Fabricate(:queue_item, video: empire, user: luke)
      return_of_the_jedi = Fabricate(:video)
      post :create, video_id: return_of_the_jedi.id
      return_of_the_jedi_queue_item = QueueItem.where(video_id: return_of_the_jedi.id, user_id: luke.id).first
      expect(return_of_the_jedi_queue_item.position).to eq(2)
    end

    it "it does no add the video to the queue if the video is already there" do
      luke = Fabricate(:user)
      session[:user_id] = luke.id
      empire = Fabricate(:video)
      Fabricate(:queue_item, video: empire, user: luke)
      post :create, video_id: empire.id
      expect(luke.queue_items.count).to eq(1)
    end
    it "redirects to the sign in page for unauthenticated users" do
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end
  end
end
