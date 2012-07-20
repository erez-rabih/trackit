class AddTrackedAttributesTo<%= name.camelize.pluralize %> < ActiveRecord::Migration
  def up
    add_column :<%= table_name %>, :tracked_attributes, :integer, :default => 0, :null => false
  end

  def down
    remove_column :<%= table_name %>, :tracked_attributes
  end
  
end
