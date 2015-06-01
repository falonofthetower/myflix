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
    let(:luke) { Fabricate(:user) }
    let(:leia) { Fabricate(:user) }

    before do
      set_current_user luke
    end

    it "redirects to the people page" do
      relationship = Fabricate(:relationship, leader: leia, follower: luke)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the the current user is the follower" do
      relationship = Fabricate(:relationship, leader: leia, follower: luke)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      hans = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: leia, follower: hans)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end
  end

  describe "POST create" do
    let(:luke) { Fabricate(:user) }
    let(:leia) { Fabricate(:user) }

    before do
      set_current_user luke
    end

    it "redirects to the people page" do
      post :create, leader_id: leia.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship of the user following the leader" do
      post :create, leader_id: leia.id
      expect(luke.following_relationships.first.leader).to eq(leia)
    end

    it "does not create a new relationship if one already exists" do
      post :create, leader_id: leia.id
      post :create, leader_id: leia.id
      expect(Relationship.count).to eq(1)
    end

    it "does not create a relationship to itself" do
      post :create, leader_id: luke.id
      expect(Relationship.count).to eq(0)
    end
  end
end
