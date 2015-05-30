require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      luke = Fabricate(:user)
      set_current_user luke
      leia = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: leia, follower: luke)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end

    it "redirects to the people page" do
      luke = Fabricate(:user)
      set_current_user(luke)
      leia = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: leia, follower: luke)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the the current user is the follower" do
      luke = Fabricate(:user)
      set_current_user(luke)
      leia = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: leia, follower: luke)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      luke = Fabricate(:user)
      set_current_user(luke)
      leia = Fabricate(:user)
      hans = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: leia, follower: hans)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end

  end
end
