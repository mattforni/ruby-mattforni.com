# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160124185600) do

  create_table "alerts", force: :cascade do |t|
    t.boolean  "active",       default: true
    t.decimal  "greater_than"
    t.decimal  "less_than"
    t.string   "name"
    t.integer  "stock_id",                    null: false
    t.datetime "triggered_at"
    t.integer  "user_id",                     null: false
  end

  create_table "blog_posts", force: :cascade do |t|
    t.text     "content",     null: false
    t.string   "description"
    t.string   "short_url",   null: false
    t.string   "title",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_posts", ["content"], name: "blog_post_content_index"
  add_index "blog_posts", ["short_url"], name: "blog_post_short_url_uniqueness", unique: true
  add_index "blog_posts", ["title"], name: "blog_post_title_uniqueness", unique: true

  create_table "holdings", force: :cascade do |t|
    t.string   "symbol",           limit: 10,                                        null: false
    t.decimal  "quantity",                    precision: 15, scale: 3,               null: false
    t.decimal  "purchase_price",              precision: 15, scale: 5,               null: false
    t.date     "purchase_date",                                                      null: false
    t.decimal  "commission_price",            precision: 15, scale: 5, default: 0.0, null: false
    t.integer  "user_id",                                                            null: false
    t.integer  "position_id",                                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "highest_price",               precision: 15, scale: 5,               null: false
    t.datetime "highest_time",                                                       null: false
    t.decimal  "lowest_price",                precision: 15, scale: 5,               null: false
    t.datetime "lowest_time"
  end

  add_index "holdings", ["position_id"], name: "holding_by_position_index"
  add_index "holdings", ["user_id", "symbol"], name: "holding_by_user_and_symbol_index"
  add_index "holdings", ["user_id"], name: "holding_by_user_index"

  create_table "portfolios", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "portfolios", ["user_id", "name"], name: "portfolio_by_user_and_name_index", unique: true

  create_table "positions", force: :cascade do |t|
    t.string   "symbol",           limit: 10,                                        null: false
    t.decimal  "quantity",                    precision: 15, scale: 3,               null: false
    t.decimal  "purchase_price",              precision: 15, scale: 5,               null: false
    t.decimal  "commission_price",            precision: 15, scale: 5, default: 0.0, null: false
    t.integer  "user_id",                                                            null: false
    t.integer  "stock_id",                                                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "portfolio_id",                                                       null: false
  end

  add_index "positions", ["stock_id"], name: "position_by_stock_index"
  add_index "positions", ["user_id", "symbol"], name: "position_by_user_and_symbol_index"
  add_index "positions", ["user_id"], name: "position_by_user_index"

  create_table "stocks", force: :cascade do |t|
    t.string   "symbol",         limit: 10,                          null: false
    t.string   "name"
    t.decimal  "previous_close",            precision: 15, scale: 5
    t.decimal  "last_trade",                precision: 15, scale: 5, null: false
    t.decimal  "lowest_price",              precision: 15, scale: 5, null: false
    t.datetime "lowest_time",                                        null: false
    t.decimal  "highest_price",             precision: 15, scale: 5, null: false
    t.datetime "highest_time",                                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["symbol"], name: "stock_by_symbol_index", unique: true

  create_table "stops", force: :cascade do |t|
    t.string   "symbol",        limit: 10,                          null: false
    t.decimal  "percentage",               precision: 15, scale: 5, null: false
    t.decimal  "stop_price",               precision: 15, scale: 5, null: false
    t.decimal  "quantity",                 precision: 15, scale: 3
    t.decimal  "highest_price",            precision: 15, scale: 5, null: false
    t.datetime "highest_time",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                           null: false
    t.integer  "position_id",                                       null: false
    t.decimal  "lowest_price",             precision: 15, scale: 5, null: false
    t.datetime "lowest_time",                                       null: false
  end

  add_index "stops", ["user_id"], name: "by_user"

  create_table "users", force: :cascade do |t|
    t.string   "email",                              null: false
    t.string   "encrypted_password",                 null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "by_email", unique: true

end
