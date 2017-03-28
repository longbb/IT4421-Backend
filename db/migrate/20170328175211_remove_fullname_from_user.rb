class RemoveFullnameFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :fullname, :string
    remove_column :users, :address, :string
    remove_column :users, :phone_number, :string
    add_column :users, :customer_id, :integer
  end
end
