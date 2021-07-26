class AddConfirmationToDevise < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end

    add_index :users, :confirmation_token, unique: true

    User.update_all(confirmed_at: Time.current)
  end
end