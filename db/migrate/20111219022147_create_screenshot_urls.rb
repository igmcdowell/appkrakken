class CreateScreenshotUrls < ActiveRecord::Migration
  def change
    create_table :screenshot_urls do |t|
      t.string :url
      t.integer :app_id

      t.timestamps
    end
    add_index :screenshot_urls, :app_id    
  end
end
