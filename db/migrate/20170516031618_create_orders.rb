class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :total_price
      t.string :status

      t.timestamps
    end
  end
end
