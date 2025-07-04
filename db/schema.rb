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

ActiveRecord::Schema[8.0].define(version: 2025_06_19_185112) do
  create_table "accounts", force: :cascade do |t|
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.string "cvu"
    t.string "alias"
    t.date "creation_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "cardNumber"
    t.date "expirationDate"
    t.string "cvv"
    t.boolean "isActive"
    t.string "type"
    t.integer "availableCredit"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_cards_on_account_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "account_id"
    t.integer "event_id"
    t.integer "transaction_id"
    t.string "name"
    t.string "description"
    t.string "color"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_categories_on_account_id"
    t.index ["event_id"], name: "index_categories_on_event_id"
    t.index ["transaction_id"], name: "index_categories_on_transaction_id"
  end

  create_table "event_dates", force: :cascade do |t|
    t.integer "transaction_id"
    t.date "date"
    t.index ["transaction_id"], name: "index_event_dates_on_transaction_id"
  end

  create_table "event_schedules", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "event_date_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date_id"], name: "index_event_schedules_on_event_date_id"
    t.index ["event_id", "event_date_id"], name: "index_event_schedules_on_event_id_and_event_date_id", unique: true
    t.index ["event_id"], name: "index_event_schedules_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "category_id"
    t.integer "account_id"
    t.string "title"
    t.text "description"
    t.string "period"
    t.index ["account_id"], name: "index_events_on_account_id"
    t.index ["category_id"], name: "index_events_on_category_id"
  end

  create_table "offers", force: :cascade do |t|
    t.integer "id_offer"
    t.string "company_offer"
    t.string "info_offer"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_offers_on_account_id"
  end

  create_table "quotas", force: :cascade do |t|
    t.integer "transaction_id", null: false
    t.integer "number"
    t.boolean "state", default: false
    t.float "quota_mount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_quotas_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "info_account"
    t.time "creation_date"
    t.decimal "amount", precision: 15, scale: 2, default: "0.0"
    t.integer "account_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "quotas_number"
    t.date "expiration_period"
    t.decimal "interest", precision: 5, scale: 2
    t.date "maturity_date"
    t.decimal "outstanding_balance", precision: 15, scale: 2
    t.string "deposit_method"
    t.integer "reference_number"
    t.string "transfer_method"
    t.integer "source_account_id"
    t.integer "target_account_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstName"
    t.string "lastName"
    t.string "clientId"
    t.integer "cuit"
    t.date "creationDate"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dni"
    t.string "username"
    t.string "password_digest"
  end

  create_table "validities", force: :cascade do |t|
    t.date "start_offer"
    t.date "end_offer"
    t.integer "account_id", null: false
    t.integer "offer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_validities_on_account_id"
    t.index ["offer_id"], name: "index_validities_on_offer_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "cards", "accounts"
  add_foreign_key "categories", "accounts"
  add_foreign_key "categories", "events"
  add_foreign_key "categories", "transactions"
  add_foreign_key "event_dates", "transactions"
  add_foreign_key "event_schedules", "event_dates"
  add_foreign_key "event_schedules", "events"
  add_foreign_key "events", "accounts"
  add_foreign_key "events", "categories"
  add_foreign_key "offers", "accounts"
  add_foreign_key "quotas", "transactions"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "accounts", column: "source_account_id"
  add_foreign_key "transactions", "accounts", column: "target_account_id"
  add_foreign_key "transactions", "categories"
  add_foreign_key "validities", "accounts"
  add_foreign_key "validities", "offers"
end
