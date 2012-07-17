require 'spec_helper'

describe :track_attributes do


  context "regular active record model" do
    describe "update_tracked_attributes" do
      it "should not be called" do
        @model = UntouchedModel.new
        @model.should_not_receive :update_tracked_attributes
        @model.save!
      end
    end
  end

  context "active record hook" do

    describe "update_tracked_attributes" do
      after do
        @model.should_receive :update_tracked_attributes
        @model.save!
      end

      it "should be called on creation" do
        @model = DummyTrackedModel.new
      end

      it "should be called on update" do
        @model = DummyTrackedModel.create!
      end

    end

    describe "@tracked_attributes" do
      it "should be set to stated attributes" do
        DummyTrackedModel.tracked_attributes.should == DummyTrackedModel::TRACKED_ATTRIBUTES
      end
    end

  end

  describe "track_attributes" do
    it "should not throw exception" do
      expect {DummyModel.track_attributes []}.not_to raise_error
    end
  end

  context "tracking attributes" do
    context "new model" do

      describe "tracked method" do
        it "should not raise exception" do
          expect {DummyTrackedModel.new.tracked}.not_to raise_error
        end

        it "should retur n TrackedAttributesInterface instance" do
          DummyTrackedModel.new.tracked.class.should eq Tracker::TrackedAttributesInterface
        end
      end

    end
  end

end
