require 'rails_helper'

describe Team do
  it "should have name" do
    expect(Team.new).to respond_to(:name)
  end

  it "it hhhh" do
  fail"this is failure"
end

end
