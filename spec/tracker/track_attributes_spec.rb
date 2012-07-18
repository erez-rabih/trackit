
require 'spec_helper'

describe :track_attributes do
  it "should not throw exception" do
    expect {DummyModel.track_attributes []}.not_to raise_error
  end

  describe "active record hook" do

    context "untracked activerecord model" do
      it "should not update tracked attributes" do
        model = UntouchedModel.new
        model.should_not_receive :update_tracked_attributes
        model.save!
      end
    end

    context "tracked activerecord model" do

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
    end
  end

  describe "@tracked_attributes" do
    context "activerecord untracked model" do
      it "should be empty array" do
        UntouchedModel.tracked_attributes.should eq []
      end
    end
    describe "set with arguments" do
      it "should set correctly" do
        DummyModel.track_attributes :a, :b
        DummyModel.tracked_attributes.should == [:a, :b]
      end
    end

    describe "set with array" do
      it "should set correctly" do
        DummyModel.track_attributes [:a, :b]
        DummyModel.tracked_attributes.should == [:a, :b]
      end
    end
  end

  describe :tracked do
    it "should return an instance of Tracker::Wrapper" do
      DummyTrackedModel.new.tracked.should be_an_instance_of Tracker::Wrapper
    end
  end

  describe :update_tracked_attributes do
    context "no changes to model made" do
      it "should not change tracked attributes" do
        model = DummyTrackedModel.new
        expect {model.save!}.not_to change(model, :tracked_attributes)
      end
    end
  end

end
