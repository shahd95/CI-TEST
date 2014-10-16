require 'rails_helper'

describe Team do
  it "should have name" do
    Team.new.should respond_to(:name)
  end

  it "this is a failing test" do
    fail "this should fail"
  end

  it "this is another failing test" do
    fail "this should fail"
  end
end
