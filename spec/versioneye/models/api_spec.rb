require 'spec_helper'

describe Api do

  describe "create_new" do

    it "creates a new api" do
      user = UserFactory.create_new
      api = Api.create_new(user)
      expect( api ).to_not be_nil
      expect( api.user_id ).to eq(user.id.to_s)
      expect( api.api_key ).to_not be_nil
    end

  end

  describe "generate_api_key" do

    it "creates a new api" do
      user = UserFactory.create_new
      api = Api.create_new(user)
      old_key = api.api_key
      api.generate_api_key!
      expect( api.api_key ).to_not eq( old_key )
    end

  end

  describe "by_user" do

    it "creates a new api" do
      user = UserFactory.create_new
      api = Api.create_new(user)
      api_db = Api.by_user( user )
      expect( api.ids ).to eq( api_db.ids )
    end

  end

  describe "user" do

    it "creates a new api" do
      user = UserFactory.create_new
      api = Api.create_new(user)
      u = api.user
      expect( user.ids ).to eq( u.ids )
    end

  end


end
