class CreateExitConditions < ActiveRecord::Migration
  def change
    create_table :exit_conditions do |t|
      t.integer :step_id
      t.integer :exit_step_id
      t.integer :min_risk
      t.integer :max_risk

      t.timestamps
    end
  end
end
