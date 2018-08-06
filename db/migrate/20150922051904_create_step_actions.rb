class CreateStepActions < ActiveRecord::Migration
  def change
    create_table :step_actions do |t|
      t.string :type
      t.integer :step_id
      t.text :content
      t.integer :position

      t.timestamps
    end
  end
end
