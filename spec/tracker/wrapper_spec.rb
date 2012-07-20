require 'spec_helper'

describe Tracker::Wrapper do

  let :model do
    DummyTrackedModel.create!
  end

  context "initialization" do

    it "should initialize with argument" do
      expect {Tracker::Wrapper.new(1)}.not_to raise_error
    end

    it "should not initialize without arguments" do
      expect {Tracker::Wrapper.new}.to raise_error
    end

    context "with ActiveRecord object" do

      let :wrapper do
        model.tracked
      end

      describe "model" do
        it "should equal to model given" do
          wrapper.model.should eq model
        end
      end

      describe "attribute_changed? queries" do
        context "tracked attributes" do
          it "should responsd to attribute_changed? query" do
            DummyTrackedModel::TRACKED_ATTRIBUTES.each do |attr|
              expect {wrapper.send("#{attr}_changed?")}.not_to raise_error
            end
          end
        end
        context "untracked attributes" do
          it "should not responsd to attribute_changed? query" do
            DummyTrackedModel::UNTRACKED_ATTRIBUTES.each do |attr|
              expect {wrapper.send("#{attr}_changed?")}.to raise_error
            end
          end
        end
        
      end

    end

  end

  context "unchanged model" do

    let :wrapper do
      model.tracked
    end

    describe :changed? do
      it "should return false" do
        wrapper.changed?.should be_false
      end
    end

    describe :changed do
      it "should return an empty array" do
        wrapper.changed.should eq []
      end
    end

    describe :attribute_changed? do
      DummyTrackedModel::TRACKED_ATTRIBUTES.each do |attr|
        context "#{attr}" do
          it "should return false" do
            wrapper.send("#{attr}_changed?").should be_false
          end
        end
      end
    end

  end

  context "changed model" do

    context "only untracked attributes were changed" do

      before do
        model.change_untracked!
      end

      let :wrapper do
        model.tracked
      end

      describe :changed? do
        it "should return false" do
          wrapper.changed?.should be_false
        end
      end

      describe :changed do
        it "should return an empty array" do
          wrapper.changed.should eq []
        end
      end

      describe :attribute_changed? do
        DummyTrackedModel::TRACKED_ATTRIBUTES.each do |attr|
          context "#{attr}" do
            it "should return false" do
              wrapper.send("#{attr}_changed?").should be_false
            end
          end
        end
      end

    end

    context "single tracked attribute was changed" do
      let :changed_attr do
        DummyTrackedModel::TRACKED_ATTRIBUTES.first
      end

      let :unchanged_attrs do
        DummyTrackedModel::TRACKED_ATTRIBUTES - [changed_attr]
      end

      before do
        model.update_attributes!(changed_attr => 0)
      end

      let :wrapper do
        model.tracked
      end

      describe :changed? do
        it "should return true" do
          wrapper.changed?.should be_true
        end
      end

      describe :changed do
        it "should not be blank" do
          wrapper.changed.should_not be_blank
        end

        it "should contain tracked attributes" do
          wrapper.changed.should eq [changed_attr]
        end
      end

      describe :attribute_changed? do
        context "changed tracked attribute" do
          it "should return true" do
            wrapper.send("#{changed_attr}_changed?").should be_true 
          end
        end

        context "unchanged tracked attribute" do
          it "should return false" do
            unchanged_attrs.each do |attr|
              wrapper.send("#{attr}_changed?").should be_false
            end
          end
        end
      end
      
    end
    

    context "multiple tracked attributes were changed" do

      before do
        model.change_tracked!
      end

      let :wrapper do
        model.tracked
      end

      describe :changed? do
        it "should return true" do
          wrapper.changed?.should be_true
        end
      end

      describe :changed do
        it "should not be blank" do
          wrapper.changed.should_not be_blank
        end

        it "should contain tracked attributes" do
          wrapper.changed.should =~ DummyTrackedModel::TRACKED_ATTRIBUTES
        end
      end

      describe :attribute_changed? do
        DummyTrackedModel::TRACKED_ATTRIBUTES.each do |attr|
          context "#{attr}" do
            it "should return true" do
              wrapper.send("#{attr}_changed?").should be_true
            end
          end
        end
      end

    end

  end

  describe "set changed / unchanged" do

    let :changed_attr do
      DummyTrackedModel::TRACKED_ATTRIBUTES.first
    end

    let :wrapper do
      model.tracked
    end

    describe :set_changed do

      context "on unchanged attribute" do

        describe "attribute_changed?" do

          it "should change response of attribute_changed?" do
            expect {
              wrapper.set_changed(changed_attr)
            }.to change(wrapper, "#{changed_attr}_changed?").from(false).to(true)
          end

        end
      end

      context "on changed attribute" do
        before do
          wrapper.set_changed(changed_attr)
        end
        describe "attribute_changed?" do
          it "should not change response" do
            expect {
              wrapper.set_changed(changed_attr)
            }.not_to change(wrapper, "#{changed_attr}_changed?")
          end
        end
      end
    end

    describe :set_unchanged do

      context "on unchanged attribute" do
        describe "attribute_changed?" do
          it "should not change response" do
            expect {
              wrapper.set_unchanged(changed_attr)
            }.not_to change(wrapper, "#{changed_attr}_changed?")
          end
        end

      end

      context "on changed attribute" do
        before do
          wrapper.set_changed(changed_attr)
        end

        it "should change response of attribute_changed?" do
          expect {
            wrapper.set_unchanged(changed_attr)
          }.to change(wrapper, "#{changed_attr}_changed?").from(true).to(false)
        end
      end
    end


  end

  describe :set_all_unchanged do

    before do
      model.change_tracked!
    end

    let :wrapper do
      model.tracked
    end

    describe :changed? do
      it "change from true to false" do
        expect {
          wrapper.set_all_unchanged
        }.to change(wrapper, :changed?).from(true).to(false)
      end
    end

    describe :changed do
      it "should be blank array" do
        expect {
          wrapper.set_all_unchanged
        }.to change(wrapper, :changed).to([])
      end
    end

  end
  describe :set_all_changed do

    let :wrapper do
      model.tracked
    end

    describe :changed? do
      it "should change from false to true" do
        expect {
          wrapper.set_all_changed
        }.to change(wrapper, :changed?).from(false).to(true)
      end
    end


    DummyTrackedModel::TRACKED_ATTRIBUTES.each do |attr| 
      describe :attribute_changed? do
        it "should return true" do
          expect {
            wrapper.set_all_changed
          }.to change(wrapper, "#{attr}_changed?").from(false).to(true)
        end
      end
    end


  end
  



end
