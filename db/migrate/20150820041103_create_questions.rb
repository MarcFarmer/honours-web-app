class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :step_id
      t.text :content

      t.timestamps
    end
  end
end
