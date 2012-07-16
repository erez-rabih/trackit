require 'spec_helper'

describe :track_attributes do
  it "should not throw exception" do
    expect {DummyModel.track_attributes []}.not_to raise_error
  end

  describe "active record hook" do

    describe "update_tracked_attributes" do
      after do
        @model.should_receive :update_tracked_attributes
        @model.save!
      end

      it "should be called on creation" do
        @model = DummyModel.new
      end

      it "should be called on update" do
        @model = DummyModel.create!
      end

    end

    describe "@tracked_attributes" do
    end

  end

end
