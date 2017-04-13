class CreateAdminSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_sessions do |t|
      t.integer :admin_id
      t.string :token_key
      t.string :status

      t.timestamps
    end
  end
end
