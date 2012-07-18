class DummyTrackedModel < ActiveRecord::Base
  TRACKED_ATTRIBUTES = [:a, :b]
  attr_accessible :a, :b, :c, :d
  track_attributes TRACKED_ATTRIBUTES
end
