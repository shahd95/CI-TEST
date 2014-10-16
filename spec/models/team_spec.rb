require 'rails_helper'

describe Team do
  it "should have name" do
    Team.new.should respond_to(:name)
  end
end
