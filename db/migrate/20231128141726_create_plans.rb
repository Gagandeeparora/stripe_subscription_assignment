class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :amount, precision: 15, scale: 10
      t.string :currency
      t.timestamps
    end
    Plan.create!(name: 'test', amount: 10, currency: 'Euro')
  end
end
