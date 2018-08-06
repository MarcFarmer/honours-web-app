class AddPathwayIdToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :pathway_id, :integer
    add_index :steps, :pathway_id
  end
end
