require 'spec_helper'

describe VideosController do
  describe "GET show" do
      context "with authenticated users" do
        before 
        session[:user_id] = Fabricate(:user).id
      it "sets the @video variable" do
        video = Fabricate(:video)

        get :show, id: video.id
        expect(assigns(:videos)).to eq(video)
      end
    end

    it "renders the show template" do

    end
  end
end
