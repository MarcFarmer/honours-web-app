class AddUniquenessToPathwayName < ActiveRecord::Migration
  def change
    add_index :pathways, :name, :unique => true
  end
end
