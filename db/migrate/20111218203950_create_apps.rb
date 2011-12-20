class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.decimal :rating, precision: 3, scale: 2
      t.text :description
      t.decimal :price, scale: 2
      t.string :version
      t.decimal :size, scale: 1
      t.integer :numratings
      t.timestamps
      t.boolean :game_center
      t.string :artwork60
      t.string :dev_site
      t.string :dev_name
      t.datetime :release_date
      t.string :primary_genre_name
      t.text :release_notes
      t.integer :primary_genre_id
      t.integer :dev_id
      t.string :game_url
      t.string :artwork100
      t.string :age_rating
      t.integer :app_id
      
      
      
    end
  end
end
