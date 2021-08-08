class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.belongs_to :question, foreign_key: true, null: false

      t.timestamps
    end

    add_index :subscriptions, %i[user_id question_id], unique: true
  end
end
