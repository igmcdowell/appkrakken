class AddIndexAppIdToApps < ActiveRecord::Migration
  def change
    add_index :apps, :app_id, :unique=>true
  end
end
