require "rails_helper"

RSpec.describe HomeController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/home").to route_to("home#index")
    end

    it "routes to #new" do
      expect(:get => "/home/new").to route_to("home#new")
    end

    it "routes to #show" do
      expect(:get => "/home/1").to route_to("home#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/home/1/edit").to route_to("home#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/home").to route_to("home#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/home/1").to route_to("home#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/home/1").to route_to("home#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/home/1").to route_to("home#destroy", :id => "1")
    end
  end
end
