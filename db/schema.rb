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

ActiveRecord::Schema.define(:version => 20151005020510) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "score"
  end

  create_table "exit_conditions", :force => true do |t|
    t.integer  "step_id"
    t.integer  "exit_step_id"
    t.integer  "min_risk"
    t.integer  "max_risk"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "instructions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pathways", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pathways", ["name"], :name => "index_pathways_on_name", :unique => true

  create_table "questions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "step_actions", :force => true do |t|
    t.string   "type"
    t.integer  "step_id"
    t.text     "content"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "steps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "pathway_id"
  end

  add_index "steps", ["pathway_id"], :name => "index_steps_on_pathway_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "pathway_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["name", "pathway_id"], :name => "index_tags_on_name_and_pathway_id", :unique => true
  add_index "tags", ["pathway_id"], :name => "index_tags_on_pathway_id"

end
