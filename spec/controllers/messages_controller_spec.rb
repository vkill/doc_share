require 'spec_helper'

describe MessagesController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'sent'" do
    it "returns http success" do
      get 'sent'
      response.should be_success
    end
  end

  describe "GET 'notifications'" do
    it "returns http success" do
      get 'notifications'
      response.should be_success
    end
  end

end
