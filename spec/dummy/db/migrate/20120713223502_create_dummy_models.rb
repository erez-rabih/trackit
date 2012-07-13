class CreateDummyModels < ActiveRecord::Migration
  def change
    create_table :dummy_models do |t|
      t.integer :a
      t.string :b
      t.boolean :c
      t.date :d

      t.timestamps
    end
  end
end
