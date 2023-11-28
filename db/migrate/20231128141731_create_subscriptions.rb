class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :stripe_subscription_id
      t.string :stripe_checkout_session_id

      t.timestamps
    end 
    add_index :subscriptions, :stripe_subscription_id
    add_index :subscriptions, :stripe_checkout_session_id
  end
end
