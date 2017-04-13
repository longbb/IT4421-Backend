class CreateSuppilers < ActiveRecord::Migration[5.0]
  def change
    create_table :suppilers do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end
