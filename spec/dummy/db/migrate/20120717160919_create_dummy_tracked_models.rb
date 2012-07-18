class CreateDummyTrackedModels < ActiveRecord::Migration
  def change
    create_table :dummy_tracked_models do |t|
      t.integer :a
      t.string :b
      t.boolean :c
      t.datetime :d

      t.timestamps
    end
  end
end
