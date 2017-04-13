class CreateVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :variants do |t|
      t.string :product_id
      t.integer :original_price
      t.integer :selling_price
      t.string :properties
      t.string :image_url
      t.integer :inventory
      t.string :status

      t.timestamps
    end
  end
end
