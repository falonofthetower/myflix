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
end
