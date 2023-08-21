# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_805_095_339) do
  create_table 'languages', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'code', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'languages_projects', force: :cascade do |t|
    t.integer 'project_id', null: false
    t.integer 'language_id', null: false
  end

  create_table 'projects', force: :cascade do |t|
    t.string 'name'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'primary_language_id'
    t.index ['primary_language_id'], name: 'index_projects_on_primary_language_id'
    t.index ['user_id'], name: 'index_projects_on_user_id'
  end

  create_table 'translations', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'value', null: false
    t.string 'scope', null: false
    t.integer 'language_id'
    t.integer 'project_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['language_id'], name: 'index_translations_on_language_id'
    t.index ['project_id'], name: 'index_translations_on_project_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.integer 'failed_attempts', default: 0, null: false
    t.string 'unlock_token'
    t.datetime 'locked_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'languages_projects', 'languages'
  add_foreign_key 'languages_projects', 'projects'
  add_foreign_key 'projects', 'languages', column: 'primary_language_id'
  add_foreign_key 'projects', 'users'
  add_foreign_key 'translations', 'languages'
  add_foreign_key 'translations', 'projects'
end
