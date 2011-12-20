class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :app_id
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :price, scale:2
      t.timestamps
    end
    add_index :prices, :app_id
  end
end
