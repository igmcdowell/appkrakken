class AddIsDecreaseToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :is_decrease, :boolean, :default => false
  end
end
