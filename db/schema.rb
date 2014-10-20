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

ActiveRecord::Schema.define(version: 20140921053801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: true do |t|
    t.integer  "bgg_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists_board_games", force: true do |t|
    t.integer "board_game_id"
    t.integer "artist_id"
  end

  create_table "board_games", force: true do |t|
    t.integer  "bgg_id"
    t.string   "primary_name"
    t.text     "names"
    t.text     "description"
    t.integer  "year_published"
    t.integer  "min_players"
    t.integer  "max_players"
    t.decimal  "playtime"
    t.decimal  "bgg_bayes_score"
    t.decimal  "bgg_user_score"
    t.decimal  "bgg_average_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "board_games", ["bgg_average_score"], name: "index_board_games_on_bgg_average_score", using: :btree
  add_index "board_games", ["bgg_bayes_score"], name: "index_board_games_on_bgg_bayes_score", using: :btree
  add_index "board_games", ["bgg_id"], name: "index_board_games_on_bgg_id", using: :btree
  add_index "board_games", ["bgg_user_score"], name: "index_board_games_on_bgg_user_score", using: :btree

  create_table "board_games_categories", force: true do |t|
    t.integer "board_game_id"
    t.integer "category_id"
  end

  create_table "board_games_families", force: true do |t|
    t.integer "board_game_id"
    t.integer "family_id"
  end

  create_table "board_games_mechanics", force: true do |t|
    t.integer "board_game_id"
    t.integer "mechanic_id"
  end

  create_table "board_games_publishers", force: true do |t|
    t.integer "board_game_id"
    t.integer "publisher_id"
  end

  create_table "categories", force: true do |t|
    t.integer  "bgg_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "families", force: true do |t|
    t.integer  "bgg_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mechanics", force: true do |t|
    t.integer  "bgg_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publishers", force: true do |t|
    t.integer  "bgg_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
