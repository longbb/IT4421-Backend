class CreateOrderVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :order_variants do |t|
      t.integer :order_id
      t.integer :variant_id
      t.integer :quantity
      t.integer :unit_price
      t.string :status

      t.timestamps
    end
  end
end
