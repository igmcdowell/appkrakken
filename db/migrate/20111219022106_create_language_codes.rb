class CreateLanguageCodes < ActiveRecord::Migration
  def change
    create_table :language_codes do |t|
      t.string :language
      t.integer :app_id

      t.timestamps
    end
    add_index :language_codes, :app_id
  end
end
