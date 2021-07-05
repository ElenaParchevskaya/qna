class AddUserIdToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :user, foreign_key: true
  end
end
