class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.text :name
      t.integer :app_id
      t.timestamps
    end
    add_index :genres, :app_id
  end
end
