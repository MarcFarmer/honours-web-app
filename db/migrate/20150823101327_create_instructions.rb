class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.integer :step_id
      t.text :content

      t.timestamps
    end
  end
end
