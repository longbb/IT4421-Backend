class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :images
      t.integer :supplier_id
      t.string :slug
      t.string :options
      t.string :status

      t.timestamps
    end
  end
end
