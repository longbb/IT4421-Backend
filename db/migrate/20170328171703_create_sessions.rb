class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.integer :user_id
      t.string :token_key
      t.string :status

      t.timestamps
    end
  end
end
