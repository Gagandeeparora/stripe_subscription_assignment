class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :stripe_id
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :stripe_id
  end
end
