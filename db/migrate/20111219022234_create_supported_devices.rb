class CreateSupportedDevices < ActiveRecord::Migration
  def change
    create_table :supported_devices do |t|
      t.string :device
      t.integer :app_id

      t.timestamps
    end
    add_index :supported_devices, :app_id
  end
end
