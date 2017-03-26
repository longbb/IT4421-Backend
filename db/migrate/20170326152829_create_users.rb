class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :email
      t.string :password_digest
      t.string :address
      t.string :phone_number
      t.string :status

      t.timestamps
    end
  end
end
