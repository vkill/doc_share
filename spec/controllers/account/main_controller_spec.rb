require 'spec_helper'

describe Account::MainController do

  describe "GET 'dashboard'" do
    it "returns http success" do
      get 'dashboard'
      response.should be_success
    end
  end

  describe "GET 'notifications_center'" do
    it "returns http success" do
      get 'notifications_center'
      response.should be_success
    end
  end

end
