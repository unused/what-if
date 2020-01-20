# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_14_232642) do

  create_table "choices", force: :cascade do |t|
    t.string "label"
    t.string "ref"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "passage_id"
    t.index ["passage_id"], name: "index_choices_on_passage_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "data_type"
    t.string "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "passages", force: :cascade do |t|
    t.string "ref"
    t.string "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "story_id"
    t.index ["story_id"], name: "index_passages_on_story_id"
  end

  create_table "passcodes", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_passcodes_on_user_id"
  end

  create_table "save_games", force: :cascade do |t|
    t.string "state_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "story_id"
    t.integer "passage_id"
    t.index ["passage_id"], name: "index_save_games_on_passage_id"
    t.index ["story_id"], name: "index_save_games_on_story_id"
    t.index ["user_id"], name: "index_save_games_on_user_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.string "styles"
    t.string "script"
    t.string "settings"
    t.string "raw"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "ask_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "active_game_id"
    t.index ["active_game_id"], name: "index_users_on_active_game_id"
  end

end
