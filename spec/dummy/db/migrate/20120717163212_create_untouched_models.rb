class CreateUntouchedModels < ActiveRecord::Migration
  def change
    create_table :untouched_models do |t|
      t.integer :a
      t.string :b
      t.boolean :c
      t.datetime :d

      t.timestamps
    end
  end
end
