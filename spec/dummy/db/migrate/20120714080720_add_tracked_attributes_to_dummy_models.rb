class AddTrackedAttributesToDummyModel < ActiveRecord::Migration
  def up
    add_column :dummy_models, :tracked_attributes, :integer, :default => 0, :null => false
  end

  def down
    remove_column :dummy_models, :tracked_attributes
  end
  
end
