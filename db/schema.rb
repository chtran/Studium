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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120725162856) do

  create_table "category_types", :force => true do |t|
    t.string   "category_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "choices", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.string   "choice_letter"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "correct",       :default => false
  end

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "choice_id"
    t.datetime "created"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "room_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "string"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "body"
    t.text     "title"
  end

  create_table "paragraphs", :force => true do |t|
    t.text     "content"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string   "action"
    t.integer  "user_id"
    t.integer  "thing_id"
    t.string   "thing_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "date_of_birth"
    t.string   "school"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "image"
    t.string   "link"
  end

  create_table "question_types", :force => true do |t|
    t.integer  "category_type_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "type_name"
    t.boolean  "need_paragraph",   :default => false
  end

  create_table "questions", :force => true do |t|
    t.text     "prompt"
    t.integer  "exp",              :default => 1400
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "paragraph_id"
    t.integer  "question_type_id"
    t.string   "title"
  end

  create_table "questions_buffers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "room_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "room_modes", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rooms", :force => true do |t|
    t.datetime "last_activity"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "question_id"
    t.string   "title"
    t.boolean  "active",        :default => true
    t.integer  "room_mode_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.integer  "room_id"
    t.integer  "status",                 :default => 0
    t.integer  "exp",                    :default => 1400
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
