class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :status, null: false, default: 1
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, %i[user_id votable_type votable_id], unique: true, name: 'unique_index_on_user_id_and_votable'
  end
end
