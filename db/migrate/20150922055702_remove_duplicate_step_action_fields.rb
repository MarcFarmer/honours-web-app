class RemoveDuplicateStepActionFields < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.remove :step_id
      t.remove :content
    end

    change_table :instructions do |t|
      t.remove :step_id
      t.remove :content
    end  
  end
end
