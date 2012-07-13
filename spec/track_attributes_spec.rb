require 'spec_helper'

describe :track_attributes do
  it "should not throw exception" do
    expect {DummyModel.track_attributes []}.not_to raise_error
  end
end
