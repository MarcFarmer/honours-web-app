class TagNamesUniqueInScopePathway < ActiveRecord::Migration
  def change
    remove_index :tags, :name
    add_index :tags, [:name, :pathway_id], unique: true
  end
end
