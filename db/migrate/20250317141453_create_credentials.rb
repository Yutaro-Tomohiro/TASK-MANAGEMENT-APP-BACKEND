class CreateCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :credentials do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.references :user, null: false, foreign_key: true, index: false

      t.timestamps
    end
  end
end
