class CreateIpadScreenshotUrls < ActiveRecord::Migration
  def change
    create_table :ipad_screenshot_urls do |t|
      t.string :url
      t.integer :app_id

      t.timestamps
    end
    add_index :ipad_screenshot_urls, :app_id
  end
end
