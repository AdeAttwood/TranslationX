# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :languages do |t|
      t.string :key, null: false
      t.string :code, null: false

      t.timestamps
    end

    change_table :projects do |t|
      t.references :primary_language, foreign_key: { to_table: :languages }, after: :user_id
    end

    create_join_table :projects, :languages, column_options: { foreign_key: true } do |t|
      t.integer :id, primary_key: true
    end
  end
end
