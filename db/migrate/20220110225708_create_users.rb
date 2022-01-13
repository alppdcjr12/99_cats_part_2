class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, not_null: true, unique: true
      t.string :password_digest, not_null: true
      t.string :session_token, not_null: true, unique: true

      t.timestamps
    end

    add_index :users, :session_token, unique: true
  end
end
