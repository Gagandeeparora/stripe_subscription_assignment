# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_28_141731) do
  create_table "plans", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.decimal "amount", precision: 15, scale: 10
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.string "stripe_subscription_id"
    t.string "stripe_checkout_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["stripe_checkout_session_id"], name: "index_subscriptions_on_stripe_checkout_session_id"
    t.index ["stripe_subscription_id"], name: "index_subscriptions_on_stripe_subscription_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["stripe_id"], name: "index_users_on_stripe_id"
  end

  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
end
