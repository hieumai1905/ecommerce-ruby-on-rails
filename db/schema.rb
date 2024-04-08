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

ActiveRecord::Schema[7.1].define(version: 2024_04_08_062406) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "email", limit: 60, null: false
    t.string "phone", limit: 15
    t.string "remember_digest"
    t.string "password_digest", null: false
    t.boolean "is_admin", default: false, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "description"
    t.string "photo_path", null: false
    t.date "start_at", null: false
    t.date "finish_at", null: false
  end

  create_table "bill_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "quantity", null: false
    t.float "price", null: false
    t.bigint "bill_id", null: false
    t.bigint "product_detail_id", null: false
    t.index ["bill_id"], name: "index_bill_details_on_bill_id"
    t.index ["id"], name: "index_bill_details_on_id", unique: true
    t.index ["product_detail_id"], name: "index_bill_details_on_product_detail_id"
  end

  create_table "bills", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "amount", null: false
    t.string "payment_method", limit: 50, null: false
    t.boolean "status", default: true, null: false
    t.text "description", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address", null: false
    t.index ["account_id"], name: "index_bills_on_account_id"
    t.index ["id"], name: "index_bills_on_id", unique: true
  end

  create_table "evaluations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content", null: false
    t.datetime "comment_at", null: false
    t.datetime "update_at", null: false
    t.bigint "account_id", null: false
    t.bigint "bill_id", null: false
    t.index ["account_id"], name: "index_evaluations_on_account_id"
    t.index ["bill_id"], name: "index_evaluations_on_bill_id"
    t.index ["id"], name: "index_evaluations_on_id", unique: true
  end

  create_table "product_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "price", null: false
    t.integer "quantity", null: false
    t.string "color", limit: 30, null: false
    t.integer "size", null: false
    t.bigint "product_id", null: false
    t.index ["id"], name: "index_product_details_on_id", unique: true
    t.index ["product_id"], name: "index_product_details_on_product_id"
  end

  create_table "product_photos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "photo_path", null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_product_photos_on_product_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "product_name", limit: 150, null: false
    t.boolean "status", default: true, null: false
    t.text "description", null: false
    t.string "category", limit: 100, null: false
    t.string "brand", limit: 100, null: false
    t.index ["id"], name: "index_products_on_id", unique: true
  end

  add_foreign_key "bill_details", "bills"
  add_foreign_key "bill_details", "product_details"
  add_foreign_key "bills", "accounts"
  add_foreign_key "evaluations", "accounts"
  add_foreign_key "evaluations", "bills"
  add_foreign_key "product_details", "products"
  add_foreign_key "product_photos", "products"
end
