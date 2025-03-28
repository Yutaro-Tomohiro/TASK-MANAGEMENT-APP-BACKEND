class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :identity, null: false
      t.string :title, null: false
      t.text :text
      t.integer :priority, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.datetime :begins_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
