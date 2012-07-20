class DummyTrackedModel < ActiveRecord::Base
  TRACKED_ATTRIBUTES = [:a, :b]
  UNTRACKED_ATTRIBUTES = [:c, :d]
  attr_accessible :a, :b, :c, :d
  track_attributes TRACKED_ATTRIBUTES


  def get_changed_attrs(attrs)
    attrs.inject({}) do |h, attr|
      h[attr] = 0
      h
    end
  end

  def get_changed_untracked_attrs_hash
    get_changed_attrs(UNTRACKED_ATTRIBUTES)
  end

  def get_changed_tracked_attrs_hash
    get_changed_attrs(TRACKED_ATTRIBUTES)
  end

  def change_untracked!
    attrs = get_changed_untracked_attrs_hash
    self.update_attributes!(attrs)
  end

  def change_tracked!
    attrs = get_changed_tracked_attrs_hash
    self.update_attributes!(attrs)
  end
  
end
