# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations do |t|
      t.string :key, null: false
      t.string :value, null: false
      t.string :scope, null: false

      t.references :language, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
