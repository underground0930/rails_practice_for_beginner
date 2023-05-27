class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :solved, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
