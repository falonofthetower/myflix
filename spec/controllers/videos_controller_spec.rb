require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { Fabricate(:video) }

    it "sets the @video variable for authenticated users" do
      set_current_user
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets the @reviews for authenticated users" do
      set_current_user
      review_1 = Fabricate(:review, video: video)
      review_2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review_1, review_2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      set_current_user
      futurama = Fabricate(:video, title: 'Futurama')
      post :search, search_term: 'rama'
      expect(assigns(:results)).to eq([futurama])
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :search, search_term: 'rama' }
    end
  end
end
