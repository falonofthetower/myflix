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

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item that is associated with the user" do
      luke = Fabricate(:user)
      set_current_user(luke)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(luke)
    end

    it "it puts the video as the last item in the queue" do
      luke = Fabricate(:user)
      set_current_user(luke)
      empire = Fabricate(:video)
      Fabricate(:queue_item, video: empire, user: luke)
      return_of_the_jedi = Fabricate(:video)
      post :create, video_id: return_of_the_jedi.id
      return_of_the_jedi_queue_item = QueueItem.where(video_id: return_of_the_jedi.id, user_id: luke.id).first
      expect(return_of_the_jedi_queue_item.position).to eq(2)
    end

    it "it does no add the video to the queue if the video is already there" do
      luke = Fabricate(:user)
      set_current_user(luke)
      empire = Fabricate(:video)
      Fabricate(:queue_item, video: empire, user: luke)
      post :create, video_id: empire.id
      expect(luke.queue_items.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: 3 }
    end
  end

  describe "DELETE destroy" do
    it "should redirect to the my_queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      luke = Fabricate(:user)
      set_current_user(luke)
      queue_item = Fabricate(:queue_item, user: luke)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "does not delete the queue item if the user doesn't own that item" do
      luke = Fabricate(:user)
      set_current_user(luke)
      leia = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: leia)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to the sign in page for unauthenticated users" do
      delete :destroy, id: 3
      expect(response).to redirect_to sign_in_path
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "normalizes the remaining queue items" do
      luke = Fabricate(:user)
      set_current_user(luke)
      light_saber = Fabricate(:queue_item, user: luke, position: 1)
      r2d2 = Fabricate(:queue_item, user: luke, position: 2)
      delete :destroy, id: light_saber.id
      expect(QueueItem.first.position).to eq(1)
    end
  end

  describe "POST update_queue" do
    it_behaves_like "requires sign in" do
      let(:action) do
        post :update_queue, queue_items: [
          { id: 2, position: 3 }, { id: 1, position: 1 }
        ]
      end
    end

    context "with valid inputs" do
      let(:empire_strikes_back) { Fabricate(:video) }
      let(:light_saber) do
        Fabricate(
          :queue_item,
          user: luke,
          position: 1,
          video: empire_strikes_back
        )
      end
      let(:r2d2) do
        Fabricate(
          :queue_item,
          user: luke,
          position: 2,
          video: empire_strikes_back
        )
      end
      let(:luke) { Fabricate(:user) }
      before do
        session[:user_id] = luke.id
      end

      it "should redirect to the my queue page" do
        set_current_user
        post :update_queue, queue_items: [
          { id: light_saber.id, position: 2 }, { id: r2d2.id, position: 1 }
        ]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [
          { id: light_saber.id, position: 2 }, { id: r2d2.id, position: 1 }
        ]
        expect(luke.queue_items).to eq([r2d2, light_saber])
      end

      it "normalizes the position numbers"  do
        post :update_queue, queue_items: [
          { id: light_saber.id, position: 3 }, { id: r2d2.id, position: 1 }
        ]
        expect(luke.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      let(:empire_strikes_back) { Fabricate(:video) }
      let(:light_saber) do
        Fabricate(
          :queue_item,
          user: luke,
          position: 1,
          video: empire_strikes_back
        )
      end
      let(:r2d2) do
        Fabricate(
          :queue_item,
          user: luke,
          position: 2,
          video: empire_strikes_back
        )
      end
      let(:luke) { Fabricate(:user) }
      before do
        session[:user_id] = luke.id
      end

      it "redirects back to my queue" do
        post :update_queue, queue_items: [
          { id: light_saber.id, position: 3.4 }, { id: r2d2.id, position: 1 }
        ]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash danger message" do
        post :update_queue, queue_items: [
          { id: light_saber.id, position: 3 }, { id: r2d2.id, position: 2.1 }
        ]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [
          { id: light_saber.id, position: 2 }, { id: r2d2.id, position: 3.4 }
        ]
        expect(light_saber.reload.position).to eq(1)
      end
    end

    context "with queue items that do not belong in the queue" do
      it "does not change the queue items" do
        luke = Fabricate(:user)
        leia = Fabricate(:user)
        session[:user_id] = leia.id
        empire_strikes_back = Fabricate(:video)
        light_saber = Fabricate(:queue_item, user: leia, position: 1, video: empire_strikes_back)
        r2d2 = Fabricate(:queue_item, user: luke, position: 1, video: empire_strikes_back)
        post :update_queue, queue_items: [{id: light_saber.id, position: 3}, {id: r2d2.id, position: 3}]
        expect(r2d2.reload.position).to eq(1)
      end
    end
  end
end
