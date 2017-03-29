class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.string :email
      t.string :feedback
      t.string :status

      t.timestamps
    end
  end
end
