require 'rails_helper'

RSpec.describe "Teams", :type => :request do
  describe "GET /teams" do
    it "works! (now write some real specs)" do
      get teams_path
      expect(response).to have_http_status(200)
    end

    it "should have JS running" do
      visit teams_path
      header = evaluate_script("$('h1').text()")
      expect(header).to include "teams"
    end
  end

end
