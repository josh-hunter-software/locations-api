class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.integer :zip_code
      t.st_point :lonlat, geographic: true
      t.timestamps
    end
    add_index :locations, :lonlat, using: :gist
    add_index :locations, :address1
  end
end
