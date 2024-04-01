class CreateEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluations do |t|
      t.string :content, null: false
      t.datetime :comment_at, null: false
      t.datetime :update_at, null: false
      t.references :account, null: false, foreign_key: true
      t.references :bill, null: false, foreign_key: true
    end

    add_index :evaluations, :id, unique: true
  end
end
