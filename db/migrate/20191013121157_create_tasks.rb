# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.timestamp :deadline
      t.integer :priority, null: false, default: 0
      t.boolean :completed, null: false, default: false
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
