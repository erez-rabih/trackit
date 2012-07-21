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
    it "should return an instance of TrackIt::Wrapper" do
      DummyTrackedModel.new.tracked.should be_an_instance_of TrackIt::Wrapper
    end
  end

  describe :update_tracked_attributes do
    let :model do
      DummyTrackedModel.new
    end

    context "no changes to model made" do
      it "should not change tracked attributes" do
        model.tracked.should_not_receive(:set_changed)
        model.save!
      end
    end

    context "change were made but not to tracked attributes" do
      it "should not change tracked attributes" do
        model.tracked.should_not_receive(:set_changed)
        model.change_untracked!
      end
    end

    context "changes were made to tracked attribute" do
      it "should set_changed attributes appropriately" do
        attrs = model.get_changed_tracked_attrs_hash
        DummyTrackedModel::TRACKED_ATTRIBUTES.each do |attr|
          model.tracked.should_receive(:set_changed).with(attr)
        end
        model.update_attributes!(attrs)
      end
    end
  end

end
