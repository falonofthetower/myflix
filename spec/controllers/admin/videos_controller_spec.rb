require "spec_helper"

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets the video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new Video
    end

    it "redirects the regular user to the home path" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "set the flash error message for regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST create" do
    context "with valid input" do
      it_behaves_like "requires sign in" do
        let(:action) { post :create }
      end

      it_behaves_like "requires admin" do
        let(:action) { post :create }
      end

      it "redirects to the add new video path" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {
          title: "Alice in Wonderland",
          category_id: category.id,
          description: "Down the rabbit hole"
        }
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a new video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {
          title: "Alice in Wonderland",
          category_id: category.id,
          description: "Down the rabbit hole"
        }
        expect(category.videos.count).to eq(1)
      end

      it "sets the flash message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {
          title: "Alice in Wonderland",
          category_id: category.id,
          description: "Down the rabbit hole"
        }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it_behaves_like "requires sign in" do
        let (:action) { post :create }
      end

      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {
          category_id: category.id,
          description: "Down the rabbit hole"
        }
        expect(category.videos.count).to eq(0)
      end

      it "renders the new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {
          category_id: category.id,
          description: "Down the rabbit hole"
        }
        expect(response).to render_template :new
      end

      it "sets the @video variable" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {
          category_id: category.id,
          description: "Down the rabbit hole"
        }
        expect(assigns(:video)).to be_present
      end

      it "sets the flash danger message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {
          category_id: category.id,
          description: "Down the rabbit hole"
        }
        expect(flash[:danger]).to be_present
      end
    end
  end
end
