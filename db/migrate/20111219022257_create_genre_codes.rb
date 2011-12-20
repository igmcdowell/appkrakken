class CreateGenreCodes < ActiveRecord::Migration
  def change
    create_table :genre_codes do |t|
      t.integer :genre
      t.integer :app_id
      t.timestamps
    end
    add_index :genre_codes, :app_id
  end
end
